module F1Results
  class Result
    attr_accessor :position, :driver, :driver_number, :driver_country_abbr, :team, :time, :gap, :laps
    attr_reader :position_name

    alias_method :no=,  :driver_number=
    alias_method :car=, :team=

    def initialize(args = {})
      args.each do |k, v|
        # rescue here in case the results table has an obscure head cell like "Driver's Fastest Time"
        send("#{k.to_s}=", v) rescue nil
      end
    end

    def position_name=(n)
      @position_name = case
      when n.to_s.empty?
        nil
      when n.to_i == 0
        n
      else
        @position = n.to_i
      end
    end
    alias_method :p=,   :position_name=
    alias_method :pos=, :position_name=

    def driver_number
      @driver_number.to_i == 0 ? nil : @driver_number.to_i
    end

    def laps
      @laps.to_i < 1 ? nil : @laps.to_i
    end

    def gap
      # TODO: parse gap properly
      @gap.to_f == 0.0 ? nil : @gap.to_f
    end
  end

  class PracticeResult < Result
    def to_a
      [position_name, driver_number, driver, team, time, gap, laps]
    end

    # TODO: to_h, to_s
  end

  class QualifyingResult < Result
    attr_accessor :q1, :q2, :q3

    def to_a
      [position_name, driver_number, driver, team, q1, q2, q3, laps]
    end

    def q1
      @time || @q1
    end

    def time
      @q3 || @q2 || @q1 || @time
    end
  end

  class RaceResult < Result
    attr_accessor :retired, :points

    alias_method :pts=, :points=

    def to_a
      [position_name, driver_number, driver, team, laps, time_or_retired, points]
    end

    def time_or_retired=(str)
      if /^[0-9]|\+/ =~ str
        @time = str
      else
        @retired = str
      end
    end
    alias_method :time_retired=, :time_or_retired=

    def time_or_retired
      time || retired
    end

    def points
      @points.to_i
    end
  end

  # TODO: PitStop < Result
  # TODO: FastestLap < Result
end
