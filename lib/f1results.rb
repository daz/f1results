require 'f1results/version'
require 'f1results/agent'
require 'f1results/event'
require 'f1results/result'

module F1Results
  BASEURL = 'http://www.formula1.com'

  # Get results from formula1.com for a given year, country, and event type
  # (race or qualifying)
  #
  #   F1Results.f1results(2010, 'australia', :qualifying)
  #
  # Returns an `F1Results::Event` object which has a method `results`, which
  # returns multiple objects of type `F1Results::Result`

  def self.fetch(year, country, type = :race)
    event = Event.new(year: year, country: country, type: type)
    event.fetch_results
    return event
  end

  def self.fetch_with_url(url)
    agent = Agent.new
    return agent.fetch_results_with_url(url)
  end
end
