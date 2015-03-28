require 'test_helper'

class AgentTest < MiniTest::Test
  include Fixtures

  def setup
    @agent = F1Results::Agent.new
  end

  def test_get_event_2015_australia_race
    event = @agent.get_event(2015, 'Australia', :race)
    assert event.race?
    assert_equal 'Australia', event.country
    assert_equal '2015 FORMULA 1 ROLEX AUSTRALIAN GRAND PRIX', event.name
    assert_equal 17, event.results.length
    assert_equal 'Lewis Hamilton', event.winner
    assert_equal 'Kevin Magnussen', event.loser
  end

  def test_get_event_2015_australia_qualifying
    event = @agent.get_event(2015, 'Australia', :qualifying)
    assert event.qualifying?
    assert_equal 'Australia', event.country
    assert_equal '2015 FORMULA 1 ROLEX AUSTRALIAN GRAND PRIX', event.name
    assert_equal 20, event.results.length
    assert_equal 'Lewis Hamilton', event.winner
    assert_equal 'Roberto Merhi', event.loser
  end

  def test_get_event_2015_australia_practice1
    event = @agent.get_event(2015, 'Australia', :practice1)
    assert event.practice?
    assert_equal 'Australia', event.country
    assert_equal '2015 FORMULA 1 ROLEX AUSTRALIAN GRAND PRIX', event.name
    assert_equal 16, event.results.length
    assert_equal 'Nico Rosberg', event.winner
    assert_equal 'Romain Grosjean', event.loser
  end

  def test_get_event_2015_malaysia_practice2
    event = @agent.get_event(2015, 'Malaysia', :practice2)
    assert event.practice?
    # assert_equal 'Australia', event.country
    # assert_equal '2015 FORMULA 1 ROLEX AUSTRALIAN GRAND PRIX', event.name
    # assert_equal 16, event.results.length
    # assert_equal 'Nico Rosberg', event.winner
    # assert_equal 'Romain Grosjean', event.loser
  end

  def test_get_event_with_bad_year
    assert_raises RuntimeError, 'No results' do
      @agent.get_event(1900, 'Australia', :race)
    end
  end

  def test_get_event_with_bad_grand_prix
    assert_raises RuntimeError, 'No results' do
      @agent.get_event(2015, 'New Zealand', :race)
    end
  end
end
