# encoding: utf-8
require 'test_helper'

class EventTest < MiniTest::Unit::TestCase
  def setup
    @event = F1Results::Event.new
    @event.results << F1Results::RaceResult.new([1, 2, 'Mark Webber', 'Red Bull Racing-Renault', 52, '1:25:11.288', 2, 25])
    @event.results << F1Results::RaceResult.new([2, 5, 'Fernando Alonso', 'Ferrari', 52, '+3.0 secs', 1, 18])
  end

  def test_to_array
    array = @event.to_a
    assert_equal 2, array.length
    assert_kind_of Array, array.first
    assert_kind_of F1Results::RaceResult, @event.results.first
  end
end