require 'test_helper'

class EventTest < MiniTest::Test
  def setup
    @event = F1Results::Event.new
    @event.results << F1Results::RaceResult.new([1, 'Mark Webber', 'AUS', 'Red Bull Racing-Renault', '1:25:11.288', 2])
    @event.results << F1Results::RaceResult.new([2, 'Fernando Alonso', 'ESP', 'Ferrari', '+3.0 secs', 1])
  end

  def test_type
    @event.type = :qualifying
    assert_equal 'qualifying', @event.type_slug
    @event.type = :practice3
    assert_equal 'practice-3', @event.type_slug
  end

  def test_country
    @event.country = 'Australia'
    assert_equal 'Australia', @event.country
    @event.country = 'great britain'
    assert_equal 'Great Britain', @event.country
  end

  def test_to_array
    array = @event.to_a
    assert_equal 2, array.length
    assert_kind_of Array, array.first
    assert_kind_of F1Results::RaceResult, @event.results.first
  end
end
