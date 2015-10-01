require 'test_helper'

class AgentTest < MiniTest::Test
  include Fixtures

  def setup
    @agent = F1Results::Agent.new
  end

  def test_get_event_2015_australia_race
    event = F1Results::Event.new(year: 2015, country: 'Australia', type: :race)
    @agent.event = event
    @agent.fetch_results
    assert_equal '2015 FORMULA 1 ROLEX AUSTRALIAN GRAND PRIX', event.name
    assert_equal 17, event.results.length
    assert_equal 'Lewis Hamilton', event.winner
    assert_equal 'Kevin Magnussen', event.loser
  end

  def test_get_event_2015_australia_qualifying
    event = F1Results::Event.new(year: 2015, country: 'Australia', type: :qualifying)
    @agent.event = event
    @agent.fetch_results
    assert_equal '2015 FORMULA 1 ROLEX AUSTRALIAN GRAND PRIX', event.name
    assert_equal 20, event.results.length
    assert_equal 'Lewis Hamilton', event.winner
    assert_equal 'Roberto Merhi', event.loser
  end

  def test_get_event_2015_australia_practice1
    event = F1Results::Event.new(year: 2015, country: 'Australia', type: :practice1)
    @agent.event = event
    @agent.fetch_results
    assert_equal '2015 FORMULA 1 ROLEX AUSTRALIAN GRAND PRIX', event.name
    assert_equal 16, event.results.length
    assert_equal 'Nico Rosberg', event.winner
    assert_equal 'Romain Grosjean', event.loser
  end

  def test_get_event_2015_malaysia_practice2
    event = F1Results::Event.new(year: 2015, country: 'Malaysia', type: :practice2)
    @agent.event = event
    @agent.fetch_results
    assert_equal '2015 FORMULA 1 PETRONAS MALAYSIA GRAND PRIX', event.name
    assert_equal 20, event.results.length
    assert_equal 'Lewis Hamilton', event.winner
    assert_equal 'Roberto Merhi', event.loser
  end

  def test_fetch_results_2015_hungary_race
    event = @agent.fetch_results_with_url('http://www.formula1.com/content/fom-website/en/championship/results/2015-race-results/2015-Hungary-results/race.html')
    assert_equal 'FORMULA 1 PIRELLI MAGYAR NAGYDÍJ 2015', event.name
    assert_equal 20, event.results.length
    assert_equal 'Sebastian Vettel', event.winner
    assert_equal 'Nico Hulkenberg', event.loser
  end

  def test_get_event_with_bad_year
    assert_raises RuntimeError do
      event = F1Results::Event.new(year: 1900, country: 'Australia', type: :race)
      @agent.event = event
      @agent.fetch_results
    end
  end

  def test_get_event_with_bad_grand_prix
    assert_raises RuntimeError do
      event = F1Results::Event.new(year: 2015, country: 'New Zealand', type: :race)
      event.fetch_results
    end
  end
end
