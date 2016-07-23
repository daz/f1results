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
      update_results
      return event
    end

    def get_results_with_url(new_url)
      event.url = new_url
      update_results
      return event
    end

    private

      def event
        @event ||= Event.new
      end

      def url
        base_path = "results.html/#{event.year}/"
        year_url = URI.join F1Results::BASE_URL, base_path, 'races.html'
        begin
          get(year_url)
        rescue Mechanize::ResponseCodeError, Net::HTTPNotFound
          raise "No results found for #{event.year}"
        end

        file_name = html_file_name
        key = meeting_key

        uri = URI.join F1Results::BASE_URL, base_path, "races/#{key}/#{file_name}"
        return uri.to_s
      end

      def update_results
        begin
          get(event.url)
          new_event = Parser.new(page).parse
          event.results = new_event.results
          event.type ||= new_event.type
          event.country ||= new_event.country
          event.name ||= new_event.name
        rescue Mechanize::ResponseCodeError, Net::HTTPNotFound
          raise "No results found at #{url}"
        end
      end

      def meeting_key
        country = event.country.parameterize
        options = page.parser.xpath('//select[@name="meetingKey"]/option')
        meeting_key_node = options.detect do |node|
          node.attr('value') =~ /^\d+\/#{country}/ || node.text.parameterize =~ /#{country}/
        end
        raise "No country '#{event.country}' found for #{event.year}" if meeting_key_node.nil?
        return meeting_key_node.attr('value')
      end

      def html_file_name
        result_types = {}
        page.parser.xpath('//a[@data-name="resultType"]').each do |node|
          key = node.text.parameterize('_').to_sym
          value = node.attr('data-value')
          result_types[key] = value
        end

        # TODO: add support for Starting Grid, Warm Up, Pit Stop Summary, Fastest Laps
        file_name = case
        when event.race?
          'race-result'
        when event.qualifying?
          result_types[:qualifying] || result_types[:overall_qualifying]
        when event.practice?
          event.type_name.parameterize
        else
          raise "No results for event type '#{event.type}' at #{event.year} #{event.country}"
        end
        return file_name + '.html'
      end

  end
end
