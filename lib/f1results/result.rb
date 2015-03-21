module F1Results
  class Result
    attr_accessor :index, :position, :driver, :team, :laps

    def initialize(row = nil)
      build(row) unless row.nil?
    end

    def position=(n)
      @position = case
      when n.to_s.empty?
        nil
      when n.to_i == 0
        n
      else
        n.to_i
      end
    end

    private

      def build(row)
        self.position = row[0]
        @driver       = row[1]
        row
      end
  end

  class PracticeResult < Result
    attr_accessor :time

    def to_a
      [position, driver, team, time, laps]
    end

    private

      def build(row)
        row = super
        @team = row[2]
        @time = row[3]
        @laps = row[4].to_i
      end
  end

  class QualifyingResult < Result
    attr_accessor :q1, :q2, :q3

    def to_a
      [position, driver, team, q1, q2, q3, laps]
    end

    def time
      q3 || q2 || q1
    end

    private

      def build(row)
        row = super
        @team = row[2]
        @q1   = row[3]
        @q2   = row[4]
        @q3   = row[5]
        @laps = row[6].to_i
      end
  end

  class RaceResult < Result
    attr_accessor :driver_country_abbr, :time, :retired, :points

    def to_a
      [position, driver, driver_country_abbr, team, time_or_retired, points]
    end

    def time_or_retired=(str)
      if /^[0-9]|\+/ =~ str
        @time = str
      else
        @retired = str
      end
    end

    def time_or_retired
      time || retired
    end

    private

      def build(row)
        row = super
        @driver_country_abbr = row[2]
        @team                = row[3]
        self.time_or_retired = row[4]
        @points              = row[5].to_i
      end
  end
end
