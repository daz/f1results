# encoding: utf-8
require 'test_helper'

class AgentTest < MiniTest::Unit::TestCase
  include Fixtures

  def setup
    @agent = F1Results::Agent.new
  end

  def test_get_event_2012_great_britain
    event = @agent.get_event(2012, 'Great Britain', :race)
    assert event.race?
    assert_equal 'Great Britain', event.country
    assert_equal '2012 FORMULA 1 SANTANDER BRITISH GRAND PRIX', event.grand_prix
    assert_equal 24, event.results.size
    assert_equal 'Mark Webber', event.winner
    assert_equal 'Vitaly Petrov', event.loser
  end

  def test_get_event_2012_great_britain_qualifying
    event = @agent.get_event(2012, 'Great Britain', :qualifying)
    assert event.qualifying?
    assert_equal 'Great Britain', event.country
    assert_equal '2012 FORMULA 1 SANTANDER BRITISH GRAND PRIX', event.grand_prix
    assert_equal 24, event.results.size
    assert_equal 'Fernando Alonso', event.winner
    assert_equal 'Charles Pic', event.loser
  end

  def test_get_event_2005_australia_qualifyng
    event = @agent.get_event(2005, 'Australia', :qualifying)
    assert_equal 'Australia', event.country
    assert_equal "2005 FORMULA 1™ Foster's Australian Grand Prix", event.grand_prix
    assert_equal 20, event.results.size
    assert_equal 'Giancarlo Fisichella', event.winner
  end

  def test_get_event_1992_hungary
    event = @agent.get_event(1992, 'Hungary', :race)
    assert_equal 'Hungary', event.country
    assert_equal '1992 Hungarian Grand Prix', event.grand_prix
    assert_equal 31, event.results.size
    assert_equal 'Ayrton Senna', event.winner
  end

  def test_get_event_with_bad_year
    assert_raises RuntimeError, 'Invalid season: 1800' do
      @agent.get_event(1800, 'Australia', :race)
    end
  end

  def test_get_event_with_bad_grand_prix
    assert_raises RuntimeError, 'Invalid Grand Prix: New Zealand' do
      @agent.get_event(2012, 'New Zealand', :race)
    end
  end

  def test_get_event_2012_9th
    event = @agent.get_event(2012, 9, :race)
    assert_equal 'Great Britain', event.country
    assert_equal '2012 FORMULA 1 SANTANDER BRITISH GRAND PRIX', event.grand_prix
  end

  def test_get_event_2012_latest
    event = @agent.get_event(2012, :latest, :race)
    assert_equal 'Hungary', event.country
    assert_equal 'FORMULA 1 ENI MAGYAR NAGYDÍJ 2012', event.grand_prix
  end
end
