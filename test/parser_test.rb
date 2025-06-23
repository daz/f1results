require 'test_helper'

class ParserTest < Minitest::Test
  include Fixtures

  def test_2016_australia_practice1
    event = events(:event_2016_australia_practice_1)
    assert_equal '2016 FORMULA 1 ROLEX AUSTRALIAN GRAND PRIX - PRACTICE 1', event.name
    assert_equal 'Australia', event.grand_prix
    assert_equal 'Albert Park Grand Prix Circuit, Melbourne', event.circuit
    assert_equal :practice1, event.type
    assert_equal 22, event.results.length
    assert_equal 'Lewis Hamilton', event.winning.driver
    assert_equal 'Carlos Sainz', event.losing.driver
  end

  def test_2016_australia_qualifying
    event = events(:event_2016_australia_qualifying)
    assert_equal '2016 FORMULA 1 ROLEX AUSTRALIAN GRAND PRIX - QUALIFYING', event.name
    assert_equal 'Australia', event.grand_prix
    assert_equal 'Albert Park Grand Prix Circuit, Melbourne', event.circuit
    assert_equal :qualifying, event.type
    assert_equal 22, event.results.length

    assert_equal 'Lewis Hamilton', event.winning.driver
    assert_equal 'Pascal Wehrlein', event.losing.driver
  end

  def test_2016_australia_race
    event = events(:event_2016_australia_race_result)
    assert_equal '2016 FORMULA 1 ROLEX AUSTRALIAN GRAND PRIX - RACE RESULT', event.name
    assert_equal 'Australia', event.grand_prix
    assert_equal 'Albert Park Grand Prix Circuit, Melbourne', event.circuit
    assert_equal :race, event.type
    assert_equal 22, event.results.length
    assert_equal 'Nico Rosberg', event.winning.driver
    assert_equal 'Daniil Kvyat', event.losing.driver
  end

  def test_1984_brazil_qualifying
    event = events(:event_1984_brazil_qualifying_0)
    assert_equal 'BRAZILIAN GRAND PRIX 1984 - QUALIFYING 0', event.name
    assert_equal 'Brazil', event.grand_prix
    assert_equal 'Autódromo Internacional do Rio de Janeiro, Brazil', event.circuit
    assert_equal :qualifying, event.type
    assert_equal 24, event.results.length
    assert_equal 'Elio de Angelis', event.winning.driver
    assert_equal 'Jonathan Palmer', event.losing.driver
  end

  def test_1984_brazil_race
    event = events(:event_1984_brazil_race_result)
    assert_equal 'BRAZILIAN GRAND PRIX 1984 - RACE RESULT', event.name
    assert_equal 'Brazil', event.grand_prix
    assert_equal 'Autódromo Internacional do Rio de Janeiro, Brazil', event.circuit
    assert_equal :race, event.type
    assert_equal 24, event.results.length
    assert_equal 'Alain Prost', event.winning.driver
    assert_equal 'Ayrton Senna', event.losing.driver
  end

  def test_1950_indianapolis_500_qualifying
    event = events(:event_1950_indianapolis_qualifying_0)
    assert_equal '1950 INDIANAPOLIS 500 - QUALIFYING 0', event.name
    assert_equal 'Indianapolis', event.grand_prix
    assert_equal 'Indianapolis Motor Speedway, United States', event.circuit
    assert_equal :qualifying, event.type
    assert_equal 1, event.results.length
    assert_equal 'Walt Faulkner', event.winning.driver
    assert_equal 'Walt Faulkner', event.losing.driver
  end

  def test_1950_indianapolis_500_race
    event = events(:event_1950_indianapolis_race_result)
    assert_equal '1950 INDIANAPOLIS 500 - RACE RESULT', event.name
    assert_equal 'Indianapolis', event.grand_prix
    assert_equal 'Indianapolis Motor Speedway, United States', event.circuit
    assert_equal :race, event.type
    # Note: 3 ties, so 36 finishers, 33 positions in this race
    assert_equal 36, event.results.length
    assert_equal 'Johnnie Parsons', event.winning.driver
    assert_equal 'Duke Dinsmore', event.losing.driver
  end

  def test_2024_belgium_race
    event = events(:event_2024_belgium_race_result)
    assert_equal 'FORMULA 1 ROLEX BELGIAN GRAND PRIX 2024 - RACE RESULT', event.name
    assert_equal 'Belgium', event.grand_prix
    assert_equal 'Circuit de Spa-Francorchamps, Spa-Francorchamps', event.circuit
    assert event.race?
    assert_equal 20, event.results.length
    # Note: George Russell won but was DQ'd, but still shows as first result
    assert_equal 'George Russell', event.winning.driver
    assert_equal 'DQ', event.results[0].position_name
    assert_equal 'Zhou Guanyu', event.losing.driver
  end
end
