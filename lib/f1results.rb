require 'f1results/version'
require 'f1results/agent'
require 'f1results/event'
require 'f1results/result'

module F1Results
  BASEURL = 'http://www.formula1.com'

  # Get results from formula1.com for a given season, country, and event type
  # (race or qualifying)
  #
  #   F1Results.get(2010, 'australia', :qualifying)
  #
  # Returns an `F1Results::Event` object which has a method `results`, which
  # returns multiple objects of type `F1Results::Result`

  def self.get(year, country, type = :race)
    agent = F1Results::Agent.new
    agent.get_event(year, country, type)
  end
end
