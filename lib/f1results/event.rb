module F1Results
  class Event
    attr_accessor :year, :grand_prix, :circuit, :type, :name, :results, :url

    def initialize(args = {})
      @results = []
      args.each { |k,v| send("#{k}=", v) }
    end

    def grand_prix_slug
      grand_prix.strip.downcase.gsub(/[:space:]+/, '-')
    end

    # Human readable type, e.g. "Practice 1", "Qualifying", "Starting Grid"
    def type_name
      @type.to_s
        .gsub(/\d/, ' \0')
        .gsub('_', ' ')
        .split(' ')
        .map(&:capitalize)
        .join(' ')
    end

    def practice?
      /^practice(1|2|3)$/ =~ @type.to_s
    end

    def practice1?
      @type == :practice1
    end

    def practice2?
      @type == :practice2
    end

    def practice3?
      @type == :practice3
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

    def [](i)
      @results[i]
    end

    def winning
      self[0]
    end

    def losing
      self[-1]
    end

    def get_results
      agent = F1Results::Agent.new
      agent.get_results(self)
    end

    def get_results_with_url(url)
      agent = F1Results::Agent.new
      agent.fetch_results_with_url(url)
    end
  end
end
