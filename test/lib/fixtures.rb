require 'f1results'
require 'webmock'

module Fixtures
  include ::WebMock::API

  STUBS = {
    'en/results.html/1900/races.html'                                  => 404,

    'en/results.html/1950/races/96/indianapolis-500/fastest-laps.html' => '1950_indianapolis_500_fastest_laps.html',
    'en/results.html/1950/races/96/indianapolis-500/qualifying-0.html' => '1950_indianapolis_500_qualifying_0.html',
    'en/results.html/1950/races/96/indianapolis-500/race-result.html'  => '1950_indianapolis_500_race_result.html',
    'en/results.html/1950/races.html'                                  => '1950_races.html',

    'en/results.html/1984/races/466/brazil/fastest-laps.html'          => '1984_brazil_fastest_laps.html',
    'en/results.html/1984/races/466/brazil/qualifying-0.html'          => '1984_brazil_qualifying_0.html',
    'en/results.html/1984/races/466/brazil/qualifying-1.html'          => '1984_brazil_qualifying_1.html',
    'en/results.html/1984/races/466/brazil/qualifying-2.html'          => '1984_brazil_qualifying_2.html',
    'en/results.html/1984/races/466/brazil/race-result.html'           => '1984_brazil_race_result.html',
    'en/results.html/1984/races/466/brazil/starting-grid.html'         => '1984_brazil_starting_grid.html',
    'en/results.html/1984/races/466/brazil/warm-up.html'               => '1984_brazil_warm_up.html',
    'en/results.html/1984/races.html'                                  => '1984_races.html',

    'en/results.html/2016/races/938/australia/fastest-laps.html'       => '2016_australia_fastest_laps.html',
    'en/results.html/2016/races/938/australia/pit-stop-summary.html'   => '2016_australia_pit_stop_summary.html',
    'en/results.html/2016/races/938/australia/practice-1.html'         => '2016_australia_practice_1.html',
    'en/results.html/2016/races/938/australia/qualifying.html'         => '2016_australia_qualifying.html',
    'en/results.html/2016/races/938/australia/race-result.html'        => '2016_australia_race_result.html',
    'en/results.html/2016/races.html'                                  => '2016_races.html'
  }


  def before_setup
    super
    STUBS.each do |array|
      stub Hash[*array]
    end
  end

  private

    def events(name)
      agent = Mechanize.new
      file = "#{name.to_s}.html"
      page = agent.get "file://#{fixture_path(file)}"
      event = F1Results::Parser.new(page).parse
      return event
    end

    def stub(hash)
      remote_uri, fixture = expand_stub_paths(hash).to_a[0]

      response = case
      when fixture.is_a?(Integer)
        { status: fixture }
      when fixture.is_a?(String)
        { status:  200,
          headers: { 'Content-Type' => 'text/html' },
          body:    File.read(fixture) }
      end

      stub_request(:get, remote_uri).to_return(response)
    end

    def fixture_path(file)
      File.join File.expand_path(File.dirname(__FILE__)), '..', 'fixtures', file
    end

    def expand_stub_paths(hash)
      remote_path, fixture = hash.to_a[0]
      remote_uri = File.join(F1Results::BASE_URL, remote_path)
      local_path = if fixture.is_a?(Integer)
        fixture
      else
        fixture_path(fixture)
      end
      return { remote_uri => local_path }
    end
end
