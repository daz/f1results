require 'test_helper'

class EventTest < MiniTest::Test
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

  def test_country
    @event.country = 'Australia'
    assert_equal 'Australia', @event.country
    @event.country = 'great britain'
    assert_equal 'Great Britain', @event.country
  end

  def test_to_array
    @event.results << F1Results::RaceResult.new(position: 1, driver: 'Mark Webber', driver_country_abbr: 'AUS', team: 'Red Bull Racing-Renault', time: '1:25:11.288', points: 2)
    @event.results << F1Results::RaceResult.new(position: 2, driver: 'Fernando Alonso', driver_country_abbr: 'ESP', team: 'Ferrari', time: '+3.0 secs', points: 1)

    array = @event.to_a
    assert_equal 2, array.length
    assert_kind_of Array, array.first
    assert_kind_of F1Results::RaceResult, @event.results.first
  end
end
