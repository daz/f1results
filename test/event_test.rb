require 'test_helper'

class EventTest < MiniTest::Test
  include Fixtures

  def setup
    @event = F1Results::Event.new
  end

  def test_type
    @event.type = :qualifying
    assert_equal 'qualifying', @event.type_slug
    @event.type = :practice3
    assert_equal 'practice-3', @event.type_slug
    @event.type = :p3
    assert_equal :practice3, @event.type
  end

  def test_practice
    @event.type = :qualifying
    refute @event.practice?
    @event.type = :practice1
    assert @event.practice?
    @event.type = :practice2
    assert @event.practice?
    @event.type = :practice3
    assert @event.practice?
    @event.type = :practice4
    refute @event.practice?
  end

  def test_country_name
    @event.country = 'great britain'
    assert_equal 'Great Britain', @event.country_name
  end

  def test_to_array
    @event.results << F1Results::RaceResult.new(position: 1, driver: 'Mark Webber', driver_country_abbr: 'AUS', team: 'Red Bull Racing-Renault', time: '1:25:11.288', points: 2)
    @event.results << F1Results::RaceResult.new(position: 2, driver: 'Fernando Alonso', driver_country_abbr: 'ESP', team: 'Ferrari', time: '+3.0 secs', points: 1)

    array = @event.to_a
    assert_equal 2, array.length
    assert_kind_of Array, array.first
    assert_kind_of F1Results::RaceResult, @event.results.first
  end

  def test_fetch_results_2015_australia_race
    event = F1Results::Event.new(year: 2015, country: 'Australia', type: :race)
    event.fetch_results
    assert_equal '2015 FORMULA 1 ROLEX AUSTRALIAN GRAND PRIX', event.name
    assert_equal 17, event.results.length
    assert_equal 'Lewis Hamilton', event.winner
    assert_equal 'Kevin Magnussen', event.loser
  end

  def test_fetch_results_2015_australia_qualifying
    event = F1Results::Event.new(year: 2015, country: 'Australia', type: :qualifying)
    event.fetch_results
    assert_equal '2015 FORMULA 1 ROLEX AUSTRALIAN GRAND PRIX', event.name
    assert_equal 20, event.results.length
    assert_equal 'Lewis Hamilton', event.winner
    assert_equal 'Roberto Merhi', event.loser
  end

  def test_fetch_results_2015_australia_practice1
    event = F1Results::Event.new(year: 2015, country: 'Australia', type: :practice1)
    event.fetch_results
    assert_equal '2015 FORMULA 1 ROLEX AUSTRALIAN GRAND PRIX', event.name
    assert_equal 16, event.results.length
    assert_equal 'Nico Rosberg', event.winner
    assert_equal 'Romain Grosjean', event.loser
  end

  def test_fetch_results_2015_malaysia_practice2
    event = F1Results::Event.new(year: 2015, country: 'Malaysia', type: :practice2)
    event.fetch_results
    assert_equal '2015 FORMULA 1 PETRONAS MALAYSIA GRAND PRIX', event.name
    assert_equal 20, event.results.length
    assert_equal 'Lewis Hamilton', event.winner
    assert_equal 'Roberto Merhi', event.loser
  end

  def test_fetch_results_2015_hungary_race
    event = F1Results::Event.new(year: 2015, country: 'Hungary', type: :race)
    event.fetch_results_from_url('http://www.formula1.com/content/fom-website/en/championship/results/2015-race-results/2015-Hungary-results/race.html')
    assert_equal 'FORMULA 1 PIRELLI MAGYAR NAGYDÍJ 2015', event.name
    assert_equal 20, event.results.length
    assert_equal 'Sebastian Vettel', event.winner
    assert_equal 'Nico Hulkenberg', event.loser
  end

  def test_fetch_results_with_bad_year
    event = F1Results::Event.new(year: 1900, country: 'Australia', type: :race)
    assert_equal [], event.fetch_results
  end

  def test_fetch_results_with_bad_grand_prix
    event = F1Results::Event.new(year: 2015, country: 'New Zealand', type: :race)
    assert_equal [], event.fetch_results
  end

end
