require_relative './f1results/version'
require_relative './f1results/agent'
require_relative './f1results/parser'
require_relative './f1results/event'
require_relative './f1results/result'

module F1Results
  BASE_URL = 'https://www.formula1.com/'

  # Get results from formula1.com for a given year, grand prix, and event type
  # (race or qualifying)
  #
  #   F1Results.f1results(2010, 'australia', :qualifying)
  #
  # Returns an `F1Results::Event` object which has a method `results`, which
  # returns multiple objects of type `F1Results::Result`

  def self.fetch(year, grand_prix, type = :race)
    event = Event.new(year: year, grand_prix: grand_prix, type: type)
    event.get_results
    return event
  end

  def self.fetch_with_url(url)
    agent = Agent.new
    return agent.get_results_with_url(url)
  end
end
