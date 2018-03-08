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
    hash = { pos: '2', no: '26', driver: 'Daniil Kvyat', car: 'Red Bull Racing TAG Heuer', time: '1:30.146', gap: '+0.421s', laps: '14' }
    result = F1Results::PracticeResult.new hash
    assert_equal 2, result.position
    assert_equal 'Daniil Kvyat', result.driver
    assert_equal 'Red Bull Racing TAG Heuer', result.team
    assert_equal '1:30.146', result.time
    assert_equal 14, result.laps
  end

  def test_parse_qualifying
    hash = { pos: '8', no: '3', driver: 'Daniel Ricciardo', car: 'Red Bull Racing TAG Heuer', q1: '1:26.945', q2: '1:25.599', q3: '1:25.589', laps: '15' }
    result = F1Results::QualifyingResult.new hash
    assert_equal 8, result.position
    assert_equal 'Daniel Ricciardo', result.driver
    assert_equal 'Red Bull Racing TAG Heuer', result.team
    assert_equal '1:26.945', result.q1
    assert_equal '1:25.599', result.q2
    assert_equal '1:25.589', result.q3
    assert_equal 15, result.laps
  end

  def test_parse_race
    hash = { pos: '3', no: '5', driver: 'Sebastian Vettel', car: 'Ferrari', laps: '57', time_retired: '+9.643s', pts: '15' }
    result = F1Results::RaceResult.new hash
    assert_equal 3, result.position
    assert_equal 'Sebastian Vettel', result.driver
    assert_equal 'Ferrari', result.team
    assert_equal '+9.643s', result.time
    assert_equal 15, result.points
  end

  def test_parse_qualifying_with_blank_values
    result = F1Results::QualifyingResult.new(position: '16', driver: 'Marcus Ericsson', team: 'Sauber', q1: '1:31.376', q2: nil, q3: nil, laps: 10)
    assert_equal '1:31.376', result.q1
    assert_nil result.q2
    assert_nil result.q3
    assert_equal 10, result.laps
  end

  def test_race_to_a
    hash = { pos: '3', no: '5', driver: 'Sebastian Vettel', car: 'Ferrari', laps: '57', time_retired: '+9.643s', pts: '15' }
    result = F1Results::RaceResult.new hash
    assert_equal [3, 5, 'Sebastian Vettel', 'Ferrari', 57, '+9.643s', 15], result.to_a
  end

  def test_unknown_key_doesnt_raise_error
    assert_nothing_raised do
      F1Results::Result.new(some_silly_column_name: 'value')
    end
  end
end
