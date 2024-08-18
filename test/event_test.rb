require 'test_helper'

class EventTest < Minitest::Test
  include Fixtures

  def setup
    @event = F1Results::Event.new
  end

  def test_type_name
    @event.type = :practice1
    assert_equal 'Practice 1', @event.type_name
    @event.type = :practice3
    assert_equal 'Practice 3', @event.type_name
    @event.type = :qualifying
    assert_equal 'Qualifying', @event.type_name
    @event.type = :race
    assert_equal 'Race', @event.type_name
    @event.type = :starting_grid
    assert_equal 'Starting Grid', @event.type_name
    @event.type = :warm_up
    assert_equal 'Warm Up', @event.type_name
    @event.type = :pit_stop_summary
    assert_equal 'Pit Stop Summary', @event.type_name
    @event.type = :fastest_laps
    assert_equal 'Fastest Laps', @event.type_name
    @event.type = :sprint
    assert_equal 'Sprint', @event.type_name
    @event.type = :sprint_grid
    assert_equal 'Sprint Grid', @event.type_name
  end

  def test_type_boolean_methods
    @event.type = :race
    assert @event.race?
    @event.type = :qualifying
    assert @event.qualifying?
    @event.type = :practice1
    assert @event.practice?
    @event.type = :practice2
    assert @event.practice?
    @event.type = :practice3
    assert @event.practice?
    @event.type = :practice4
    refute @event.practice?
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
