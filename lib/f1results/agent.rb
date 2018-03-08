require 'mechanize'

module F1Results
  class Agent < ::Mechanize

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
        base_uri = URI.join F1Results::BASE_URL, "en/results.html/#{event.year}/"

        year_uri = URI.join base_uri, 'races.html'
        begin
          get(year_uri)
        rescue Mechanize::ResponseCodeError, Net::HTTPNotFound
          raise "No results found for #{event.year}"
        end

        race_result_uri = URI.join base_uri, "races/#{meeting_key}/race-result.html"

        return race_result_uri.to_s if event.race?

        begin
          get(race_result_uri)
        rescue Mechanize::ResponseCodeError, Net::HTTPNotFound
          raise "No country '#{event.country}' found for #{event.year}"
        end

        uri = URI.join base_uri, event_path
        return uri.to_s
      end

      def meeting_key
        # Find option tag with meetingKey or enclosed text that matches country name

        meeting_key_option_nodes = page.parser.xpath('//select[@name="meetingKey"]/option')
        meeting_key_option_node = meeting_key_option_nodes.detect do |node|
          node.attr('value') =~ /^\d+\/#{event.country_slug}/ || node.text.parameterize == event.country_slug
        end
        raise "No country '#{event.country}' found for #{event.year}" if meeting_key_option_node.nil?

        return meeting_key_option_node.attr('value')
      end

      def event_path
        paths = {}
        page.parser.xpath('//a[@data-name="resultType"]').each do |node|
          key = node.text.parameterize(separator: '').to_sym
          paths[key] = node.attr('href')
        end

        # TODO: add support for Starting Grid, Warm Up, Pit Stop Summary, Fastest Laps
        path = case
        when event.race?
          paths[:raceresult]
        when event.qualifying?
          paths[:qualifying] || paths[:overallqualifying]
        when event.practice?
          paths[event.type]
        end

        raise "No results for event type '#{event.type}' at #{event.year} #{event.country}" if path.nil?

        return path
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
