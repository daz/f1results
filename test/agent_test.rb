require 'test_helper'

class AgentTest < Minitest::Test
  include Fixtures

  def setup
    @agent = F1Results::Agent.new
  end

  def test_get_url_2016_australia_practice1
    event = F1Results::Event.new(year: 2016, grand_prix: 'Australia', type: :practice1)
    url = 'https://www.formula1.com/en/results/2016/races/938/australia/practice/1'
    assert_equal url, @agent.get_url(event)
  end

  def test_get_url_2016_australia_qualifying
    event = F1Results::Event.new(year: 2016, grand_prix: 'Australia', type: :qualifying)
    url = 'https://www.formula1.com/en/results/2016/races/938/australia/qualifying'
    assert_equal url, @agent.get_url(event)
  end

  def test_get_url_2016_australia_race
    event = F1Results::Event.new(year: 2016, grand_prix: 'Australia', type: :race)
    url = 'https://www.formula1.com/en/results/2016/races/938/australia/race-result'
    assert_equal url, @agent.get_url(event)
  end

  def test_get_url_1984_brazil_qualifying
    event = F1Results::Event.new(year: 1984, grand_prix: 'Brazil', type: :qualifying)
    url = 'https://www.formula1.com/en/results/1984/races/466/brazil/qualifying/0'
    assert_equal url, @agent.get_url(event)
  end

  def test_get_url_1984_brazil_race
    event = F1Results::Event.new(year: 1984, grand_prix: 'Brazil', type: :race)
    url = 'https://www.formula1.com/en/results/1984/races/466/brazil/race-result'
    assert_equal url, @agent.get_url(event)
  end

  def test_get_url_1950_indianapolis_500_qualifying
    event = F1Results::Event.new(year: 1950, grand_prix: 'Indianapolis', type: :qualifying)
    url = 'https://www.formula1.com/en/results/1950/races/96/indianapolis/qualifying/0'
    assert_equal url, @agent.get_url(event)
  end

  def test_get_url_1950_indianapolis_500_race
    event = F1Results::Event.new(year: 1950, grand_prix: 'Indianapolis', type: :race)
    url = 'https://www.formula1.com/en/results/1950/races/96/indianapolis/race-result'
    assert_equal url, @agent.get_url(event)
  end

  def test_get_results_1950_indianapolis_500_race
    event = F1Results::Event.new(year: 1950, grand_prix: 'Indianapolis', type: :race)
    event = @agent.get_results(event)
    assert_equal 36, event.results.length
  end

  def test_api
    event = F1Results.fetch(1950, 'Indianapolis', :race)
    assert_equal 36, event.results.length
  end

  def test_event_with_bad_year
    assert_raise_with_message RuntimeError, "No grand prix 'Australia' found for 1900" do
      event = F1Results::Event.new(year: 1900, grand_prix: 'Australia', type: :race)
      @agent.get_url(event)
    end
  end

  def test_event_with_bad_country
    assert_raise_with_message RuntimeError, "No grand prix 'New Zealand' found for 2016" do
      event = F1Results::Event.new(year: 2016, grand_prix: 'New Zealand', type: :race)
      @agent.get_url(event)
    end
  end

  def test_event_with_bad_event_name
    assert_raise_with_message RuntimeError, "Unsupported event type 'practice4'" do
      event = F1Results::Event.new(year: 2016, grand_prix: 'Australia', type: :practice4)
      @agent.get_url(event)
    end
  end
end
