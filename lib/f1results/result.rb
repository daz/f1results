module F1Results
  class Result
    attr_accessor :index, :position, :driver, :driver_number, :driver_country_abbr, :team, :time, :gap, :laps

    def initialize(args = {})
      args.each { |k,v| send("#{k.to_s}=", v) }
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

    def driver_number
      @driver_number.to_i == 0 ? nil : @driver_number.to_i
    end

    def laps
      @laps.to_i < 1 ? nil : @laps.to_i
    end

    def gap
      @gap.to_f == 0.0 ? nil : @gap.to_f
    end
  end

  class PracticeResult < Result
    def to_a
      [position, driver_number, driver, team, time, gap, laps]
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
  end

  class RaceResult < Result
    attr_accessor :retired, :points

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

    def points
      @points.to_i
    end
  end
end
