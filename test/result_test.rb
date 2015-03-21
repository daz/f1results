require 'test_helper'

class ResultTest < MiniTest::Test
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

  def test_qualifying_time
    result = F1Results::QualifyingResult.new
    result.q1 = '1:46.000'
    result.q2 = '1:46.515'
    result.q3 = nil
    assert_equal '1:46.515', result.time
  end

  def test_parse_practice
    result = F1Results::PracticeResult.new(['4', 'Carlos Sainz', 'Toro Rosso', '1:31.014',	'32'])
    assert_equal 4, result.position
    assert_equal 'Carlos Sainz', result.driver
    assert_equal 'Toro Rosso', result.team
    assert_equal '1:31.014', result.time
    assert_equal 32, result.laps
  end

  def test_parse_qualifying
    result = F1Results::QualifyingResult.new(['2', 'Nico Rosberg', 'Mercedes', '1:28.906', '1:27.097', '1:26.921', '14'])
    assert_equal 2, result.position
    assert_equal 'Nico Rosberg', result.driver
    assert_equal 'Mercedes', result.team
    assert_equal '1:28.906', result.q1
    assert_equal '1:27.097', result.q2
    assert_equal '1:26.921', result.q3
    assert_equal 14, result.laps
  end

  def test_parse_race
    result = F1Results::RaceResult.new(['3', 'Sebastian Vettel', 'GER', 'Ferrari', '+34.523s', '15'])
    assert_equal 3, result.position
    assert_equal 'Sebastian Vettel', result.driver
    assert_equal 'Ferrari', result.team
    assert_equal '+34.523s', result.time
    assert_equal 15, result.points
  end

  def test_parse_qualifying_with_blank_values
    result = F1Results::QualifyingResult.new(['16', 'Marcus Ericsson', 'Sauber', '1:31.376', nil, nil, 10])
    assert_equal '1:31.376', result.q1
    assert_equal nil, result.q2
    assert_equal nil, result.q3
    assert_equal 10, result.laps
  end

  def test_race_to_a
    result = F1Results::RaceResult.new(['3', 'Sebastian Vettel', 'GER', 'Ferrari', '+34.523s', '15'])
    assert_equal [3, 'Sebastian Vettel', 'GER', 'Ferrari', '+34.523s', 15], result.to_a
  end
end
