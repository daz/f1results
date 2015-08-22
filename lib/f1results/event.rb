require 'active_support/core_ext/string'

module F1Results
  class Event
    attr_accessor :year, :country, :type, :name, :results

    TYPE_ALIASES = {
      p1: :practice1,
      p2: :practice2,
      p3: :practice3,
      q:  :qualifying,
      r:  :race
    }

    def initialize(args = {})
      @results = []
      args.each { |k,v| send("#{k}=", v) }
    end

    def country_name
      @country.titleize
    end

    def country_slug
      @country.parameterize
    end

    def type=(type)
      @type = TYPE_ALIASES[type] || type
    end

    # Human readable type, e.g. "Practice 1", "Qualifying"
    def type_name
      @type.to_s.gsub(/\d/, ' \0').capitalize
    end

    def type_slug
      type_name.parameterize
    end

    def practice?
      /^practice(1|2|3)$/ =~ @type.to_s
    end

    def qualifying?
      @type == :qualifying
    end

    def race?
      @type == :race
    end

    def to_a
      @results.map(&:to_a)
    end

    def winner
      @results.first.driver
    end

    def loser
      @results.last.driver
    end

    def fetch_results
      agent = F1Results::Agent.new
      page = agent.get_page_from_default_url(self)
      parse_page(page)
      return @results
    end

    def fetch_results_from_url(url)
      agent = F1Results::Agent.new
      page = agent.get_page_from_url(url)
      parse_page(page)
      return @results
    end

    private

      def parse_page(page)
        return if page.nil?
        @name = page.parser.xpath('//a[contains(@class, "level-0")]').text
        table = page.parser.xpath('//tbody')
        parse_results_table(table)
      end

      def parse_results_table(table)
        @results = []

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

        data.each_with_index do |row, i|
          klass = case
          when practice?
            PracticeResult
          when qualifying?
            QualifyingResult
          when race?
            RaceResult
          end

          hash = Hash[header.zip(row)]
          hash[:index] = i

          result = klass.new(hash)
          @results << result
        end
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
