require 'test_helper'

class AgentTest < MiniTest::Test
  include Fixtures

  def setup
    @agent = F1Results::Agent.new
  end

  def test_get_url_2016_australia_practice1
    event = F1Results::Event.new(year: 2016, country: 'Australia', type: :practice1)
    url = 'http://www.formula1.com/content/fom-website/en/results.html/2016/races/938/australia/practice-1.html'
    assert_equal url, @agent.get_url(event)
  end

  def test_get_url_2016_australia_qualifying
    event = F1Results::Event.new(year: 2016, country: 'Australia', type: :qualifying)
    url = 'http://www.formula1.com/content/fom-website/en/results.html/2016/races/938/australia/qualifying.html'
    assert_equal url, @agent.get_url(event)
  end

  def test_get_url_2016_australia_race
    event = F1Results::Event.new(year: 2016, country: 'Australia', type: :race)
    url = 'http://www.formula1.com/content/fom-website/en/results.html/2016/races/938/australia/race-result.html'
    assert_equal url, @agent.get_url(event)
  end

  def test_get_url_1984_brazil_qualifying
    event = F1Results::Event.new(year: 1984, country: 'Brazil', type: :qualifying)
    url = 'http://www.formula1.com/content/fom-website/en/results.html/1984/races/466/brazil/qualifying-0.html'
    assert_equal url, @agent.get_url(event)
  end

  def test_get_url_1984_brazil_race
    event = F1Results::Event.new(year: 1984, country: 'Brazil', type: :race)
    url = 'http://www.formula1.com/content/fom-website/en/results.html/1984/races/466/brazil/race-result.html'
    assert_equal url, @agent.get_url(event)
  end

  def test_get_url_1950_indianapolis_500_qualifying
    event = F1Results::Event.new(year: 1950, country: 'United States', type: :qualifying)
    url = 'http://www.formula1.com/content/fom-website/en/results.html/1950/races/96/indianapolis-500/qualifying-0.html'
    assert_equal url, @agent.get_url(event)
  end

  def test_get_url_1950_indianapolis_500_race
    event = F1Results::Event.new(year: 1950, country: 'United States', type: :race)
    url = 'http://www.formula1.com/content/fom-website/en/results.html/1950/races/96/indianapolis-500/race-result.html'
    assert_equal url, @agent.get_url(event)
  end

  def test_get_results_1950_indianapolis_500_race
    event = F1Results::Event.new(year: 1950, country: 'United States', type: :race)
    event = @agent.get_results(event)
    assert_equal 36, event.results.length
  end

  def test_api
    event = F1Results.fetch(1950, 'United States', :race)
    assert_equal 36, event.results.length
  end

  def test_event_with_bad_year
    assert_raise_with_message RuntimeError, 'No results found for 1900' do
      event = F1Results::Event.new(year: 1900, country: 'Australia', type: :race)
      @agent.get_url(event)
    end
  end

  def test_event_with_bad_grand_prix
    assert_raise_with_message RuntimeError, "No country 'New Zealand' found for 2016" do
      event = F1Results::Event.new(year: 2016, country: 'New Zealand', type: :race)
      @agent.get_url(event)
    end
  end

  def test_event_with_bad_event_name
    assert_raise_with_message RuntimeError, "No results for event type 'practice4' at 2016 Australia" do
      event = F1Results::Event.new(year: 2016, country: 'Australia', type: :practice4)
      @agent.get_url(event)
    end
  end
end
