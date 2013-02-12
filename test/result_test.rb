# encoding: utf-8
require 'test_helper'

class ResultTest < MiniTest::Unit::TestCase
  def test_time
    result = F1Results::RaceResult.new
    result.time_or_retired = '1:25:11.288'
    assert_equal '1:25:11.288', result.time
  end

  def test_relative_time
    result = F1Results::RaceResult.new
    result.time_or_retired = '+3.0 secs'
    assert_equal '+3.0 secs', result.time
  end

  def test_retired
    result = F1Results::RaceResult.new
    result.time_or_retired = 'Accident'
    assert_equal 'Accident', result.retired
    result.time_or_retired = 'Gear box'
    assert_equal 'Gear box', result.retired
  end

  def test_parse_race
    result = F1Results::RaceResult.new(['5', '9', 'Kimi Räikkönen', 'Lotus-Renault', '52', '+10.3 secs', '6', '10'])
    assert_equal 5, result.position
    assert_equal 9, result.driver_number
    assert_equal 'Kimi Räikkönen', result.driver
    assert_equal 'Lotus-Renault', result.team
    assert_equal 52, result.laps
    assert_equal '+10.3 secs', result.time
    assert_equal 6, result.grid
    assert_equal 10, result.points
  end

  def test_parse_qualifying
    result = F1Results::QualifyingResult.new(['1', '5', 'Fernando Alonso', 'Ferrari', '1:46.515', '1:56.921', '1:51.746', '25'])
    assert_equal 1, result.position
    assert_equal 5, result.driver_number
    assert_equal 'Fernando Alonso', result.driver
    assert_equal 'Ferrari', result.team
    assert_equal '1:46.515', result.q1
    assert_equal '1:56.921', result.q2
    assert_equal '1:51.746', result.q3
    assert_equal 25, result.laps
  end

  def test_parse_qualifying_with_blank_values
    result = F1Results::QualifyingResult.new(['1', '5', 'Fernando Alonso', 'Ferrari', '1:46.515', '', '', ''])
    assert_equal '1:46.515', result.q1
    assert_equal nil, result.q2
    assert_equal nil, result.q3
    assert_equal 0, result.laps
  end

  def test_race_to_a
    result = F1Results::RaceResult.new(['5', '9', 'Kimi Räikkönen', 'Lotus-Renault', '52', '+10.3 secs', '6', '10'])
    assert_equal [5, 9, 'Kimi Räikkönen', 'Lotus-Renault', 52, '+10.3 secs', 6, 10], result.to_a
  end
end
