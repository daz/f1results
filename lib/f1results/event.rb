require 'active_support/core_ext/string'

module F1Results
  class Event
    attr_accessor :season, :country, :type, :name, :results

    TYPES = {
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

    def country
      @country.titleize
    end

    def country_slug
      @country.parameterize
    end

    def type=(type)
      if type.to_s.length <= 2
        @type = TYPES[type]
      else
        @type = type
      end
    end

    # Human readable type, e.g. "Practice 1", "Qualifying"
    def type_name
      @type.to_s.gsub(/\d/, ' \0').capitalize
    end

    def type_slug
      type_name.parameterize
    end

    def practice?
      @type.to_s.gsub(/\d/, '') == 'practice'
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

    def parse_results_table(table)
      @results = []

      # Remove driver abbreviation from cell, shown only in race results
      table.xpath('//span[@class="tla"]').each(&:remove)

      # Turn HTML table into an array of arrays
      data = table.xpath('//tr').map do |row|
        row.xpath('./td').map do |cell|
          cell = cell.text.gsub(/[[:space:]]+/, ' ').strip
          cell.blank? ? nil : cell
        end
      end

      # Remove rows with empty position cells (Q1 107% Time), and table header if it's there
      data.reject! { |row| row[0].nil? || row[0] == 'P' }

      data.each_with_index do |row, i|
        klass = case
        when practice?
          PracticeResult
        when qualifying?
          QualifyingResult
        when race?
          RaceResult
        end

        result = klass.new(row)
        result.index = i
        @results << result
      end

      self
    end
  end
end
