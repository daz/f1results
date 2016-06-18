require 'active_support/core_ext/string'

module F1Results
  class Event
    attr_accessor :year, :country, :country_slug, :type, :name, :results, :url

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

    def type=(type)
      type = type.to_s.downcase.gsub(' ', '').to_sym
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
