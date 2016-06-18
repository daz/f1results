require 'test_helper'

class ParserTest < MiniTest::Test
  include Fixtures

  def test_2016_australia_practice1
    event = events(:'2016_australia_practice_1')
    assert_equal '2016 FORMULA 1 ROLEX AUSTRALIAN GRAND PRIX - PRACTICE 1', event.name
    assert_equal 'Australia', event.country
    assert_equal :practice1, event.type
    assert_equal 22, event.results.length
    assert_equal 'Lewis Hamilton', event.winning.driver
    assert_equal 'Carlos Sainz', event.losing.driver
  end

  def test_2016_australia_qualifying
    event = events(:'2016_australia_qualifying')
    assert_equal '2016 FORMULA 1 ROLEX AUSTRALIAN GRAND PRIX - QUALIFYING', event.name
    assert_equal 'Australia', event.country
    assert_equal :qualifying, event.type
    assert_equal 22, event.results.length
    assert_equal 'Lewis Hamilton', event.winning.driver
    assert_equal 'Pascal Wehrlein', event.losing.driver
  end

  def test_2016_australia_race
    event = events(:'2016_australia_race_result')
    assert_equal '2016 FORMULA 1 ROLEX AUSTRALIAN GRAND PRIX - RACE RESULT', event.name
    assert_equal 'Australia', event.country
    assert_equal :race, event.type
    assert_equal 22, event.results.length
    assert_equal 'Nico Rosberg', event.winning.driver
    assert_equal 'Daniil Kvyat', event.losing.driver
  end

  def test_1984_brazil_qualifying
    event = events(:'1984_brazil_qualifying_0')
    assert_equal 'Brazilian Grand Prix 1984 - OVERALL QUALIFYING', event.name
    assert_equal 'Brazil', event.country
    assert_equal :qualifying, event.type
    assert_equal 24, event.results.length
    assert_equal 'Elio de Angelis', event.winning.driver
    assert_equal 'Jonathan Palmer', event.losing.driver
  end

  def test_1984_brazil_race
    event = events(:'1984_brazil_race_result')
    assert_equal 'Brazilian Grand Prix 1984 - RACE RESULT', event.name
    assert_equal 'Brazil', event.country
    assert_equal :race, event.type
    assert_equal 24, event.results.length
    assert_equal 'Alain Prost', event.winning.driver
    assert_equal 'Ayrton Senna', event.losing.driver
  end

  def test_1950_indianapolis_500_qualifying
    event = events(:'1950_indianapolis_500_qualifying_0')
    assert_equal '1950 Indianapolis 500 - QUALIFYING', event.name
    assert_equal 'United States', event.country
    assert_equal :qualifying, event.type
    assert_equal 1, event.results.length
    assert_equal 'Walt Faulkner', event.winning.driver
    assert_equal 'Walt Faulkner', event.losing.driver
  end

  def test_1950_indianapolis_500_race
    event = events(:'1950_indianapolis_500_race_result')
    assert_equal '1950 Indianapolis 500 - RACE RESULT', event.name
    assert_equal 'United States', event.country
    assert_equal :race, event.type
    # Note: 3 ties, so 36 finishers, 33 positions in this race
    assert_equal 36, event.results.length
    assert_equal 'Johnnie Parsons', event.winning.driver
    assert_equal 'Duke Dinsmore', event.losing.driver
  end
end
