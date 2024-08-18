require 'mechanize'

module F1Results
  class Agent < ::Mechanize
    def initialize
      super
      self.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    def get_url(event)
      @event = event
      return url
    end

    def get_results(new_event)
      @event = new_event
      event.url ||= url
      update_event
      return event
    end

    def get_results_with_url(new_url)
      event.url = new_url
      update_event
      return event
    end

    private

      def event
        @event ||= Event.new
      end

      def url
        base_uri = URI.join F1Results::BASE_URL, "en/results/#{event.year}/"
        year_uri = URI.join base_uri, 'races'
        begin
          get(year_uri)
        rescue Mechanize::ResponseCodeError, Net::HTTPNotFound
          raise "No results found for #{event.year}"
        end

        grand_prix_nodes = page.parser.xpath("//table[contains(@class, 'f1-table')]/tbody/tr/td[1]//a")
        grand_prix_node = grand_prix_nodes.find { |node| node.text.downcase == event.country.downcase }
        raise "No country '#{event.country}' found for #{event.year}" if grand_prix_node.nil?

        grand_prix_uri = URI.join base_uri, grand_prix_node.attr('href')

        begin
          get(grand_prix_uri)
        rescue Mechanize::ResponseCodeError, Net::HTTPNotFound
          raise "Error fetching #{grand_prix_uri}"
        end

        event_names = {
          "race result" => :race_result_node,
          "fastest laps" => :fastest_laps_node,
          "pit stop summary" => :pit_stop_summary_node,
          "starting grid" => :starting_grid_node,
          "overall qualifying" => :overall_qualifying_node,
          "qualifying" => :qualifying_node,
          "practice 3" => :practice3_node,
          "practice 2" => :practice2_node,
          "practice 1" => :practice1_node,
          "sprint" => :sprint_node,
          "sprint grid" => :sprint_grid_node,
          "sprint qualifying" => :sprint_qualifying_node
        }

        event_nodes = page.parser.xpath("//ul[contains(@class, 'f1-sidebar-wrapper')]//li/a")

        # Create a hash to store the nodes
        nodes = {}
        event_names.each do |name, key|
          nodes[key] = event_nodes.find { |node| node.text.strip.downcase == name }
        end

        # TODO: add support for Starting Grid, Warm Up, Pit Stop Summary, Fastest Laps
        node = case
        when event.race?
          nodes[:race_result_node]
        when event.qualifying?
          nodes[:qualifying_node] || nodes[:overall_qualifying_node]
        when event.practice3?
          nodes[:practice3_node]
        when event.practice2?
          nodes[:practice2_node]
        when event.practice1?
          nodes[:practice1_node]
        else
          raise "Unsupported event type '#{event.type}'"
        end

        raise "No results for event type '#{event.type}' at #{event.year} #{event.country}" if node.nil?

        uri = URI.join base_uri, node.attr('href')
        return uri.to_s
      end

      def update_event
        begin
          get(event.url)
        rescue Mechanize::ResponseCodeError, Net::HTTPNotFound
          raise "No results found at '#{url}'"
        end

        new_event = Parser.new(page).parse
        event.type ||= new_event.type
        validate_event(new_event)

        event.country ||= new_event.country
        event.circuit ||= new_event.circuit
        event.name ||= new_event.name
        event.results = new_event.results
      end

      def validate_event(new_event)
        if event.type != new_event.type
          raise "Results at '#{url}' are returning from '#{new_event.type_name}', not the requested '#{event.type_name}'"
        end
      end

  end
end
