module F1Results
  class Event
    attr_accessor :season, :country, :type, :grand_prix, :results

    def initialize(args)
      args.each { |k,v| send("#{k}=", v) }
      @results = []
    end

    def country
      @country.split(/(\W)/).map(&:capitalize).join
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
      data = table.xpath('//tr[not(position()=1)]').map do |row|
        row.xpath('./td').map do |col|
          col.text.strip
        end
      end

      data.each_with_index do |row, i|
        klass = qualifying? ? QualifyingResult : RaceResult
        result = klass.new(row)
        result.index = i + 1
        @results << result unless result.position.nil?
      end

      self
    end
  end
end
