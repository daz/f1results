module F1Results
  class Result
    attr_accessor :index, :position, :driver, :driver_number, :team, :time, :retired, :laps

    def initialize(row = nil)
      build(row) unless row.nil?
    end

    def position=(n)
      @position = case
      when n == ''
        nil
      when n.to_i == 0
        n
      else
        n.to_i
      end
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
      self.position = row[0]
      @driver_number = row[1].to_i
      @driver = row[2]
      @team = row[3]
    end
  end

  class QualifyingResult < Result
    attr_accessor :q1, :q2, :q3

    def to_a
      [position, driver_number, driver, team, q1, q2, q3, laps]
    end

    private

    def build(row)
      @q1 = row[4]
      if row.length > 5
        @q2 = row[5]
        @q3 = row[6]
        @laps = row[7].to_i
      end
      super
    end
  end

  class RaceResult < Result
    attr_accessor :grid, :points

    def to_a
      [position, driver_number, driver, team, laps, time_or_retired, grid, points]
    end

    private

    def build(row)
      @laps = row[4].to_i
      self.time_or_retired = row[5]
      @grid = row[6].to_i
      @points = row[7].to_i
      super
    end
  end
end
