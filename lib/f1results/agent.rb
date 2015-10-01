require 'mechanize'

module F1Results
  class Agent < ::Mechanize
    attr_accessor :event

    def initialize(event = nil)
      if event.nil?
        @event = F1Results::Event.new
      else
        self.event = event
      end
      super
    end

    def fetch_results
      return fetch_results_with_url(@default_url)
    end

    def fetch_results_with_url(url)
      begin
        get(url)
        @event.name = parse_event_title
        @event.results = parse_event_results
        return @event
      rescue Mechanize::ResponseCodeError, Net::HTTPNotFound
        raise "No results found at #{url}"
      end
    end

    def event=(event)
      path = "content/fom-website/en/championship/results/#{event.year}-race-results/#{event.year}-#{event.country_slug}-results/#{event.type_slug}.html"
      @default_url = ::File.join F1Results::BASEURL, path
      @event = event
    end

    private

      def parse_event_title
        return page.parser.xpath('//a[contains(@class, "level-0")]').text
      end

      def parse_event_results
        results = []
        table = page.parser.xpath('//tbody')

        # Remove driver abbreviation from cell
        table.xpath('//span[@class="tla"]').each(&:remove)

        # Turn HTML table into an array of arrays
        data = table.xpath('//tr').map do |row|
          row.xpath('./td|./th').map do |cell|
            cell = cell.text.gsub(/[[:space:]]+/, ' ').strip
            cell.blank? ? nil : cell
          end
        end

        # Remove rows that have the cell "Q1 107% Time"
        regex = /107%/
        data.reject! { |row| row.any? { |cell| regex =~ cell } }

        header = parse_table_header(data.shift)

        result_class = case
        when @event.practice?
          PracticeResult
        when @event.qualifying?
          QualifyingResult
        else
          RaceResult
        end

        data.each_with_index do |row, i|
          hash = Hash[header.zip(row)]
          hash[:index] = i

          result = result_class.new(hash)
          results << result
        end

        return results
      end

      # Turn array of words to symbols
      def parse_table_header(header)
        header.map do |cell|
          # Fix i18n cells that look like this
          # {'Position' @ i18n}, {'Driver' @ i18n}, ...
          cell = cell.match(/(')(.+)(')/)[2] if /i18n/ =~ cell
          cell.to_s.strip.parameterize('_').to_sym
        end
      end
  end
end
