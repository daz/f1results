require 'f1results'
require 'webmock'
module Fixtures
  include ::WebMock::API

  FIXTURES_DIR = File.expand_path('../../fixtures', __FILE__)

  STUBS = {
    'en/results.html/1900/races'                           => 404,

    'en/results/1950/races/96/indianapolis/fastest-laps'   => '1950_indianapolis_500_fastest_laps.html',
    'en/results/1950/races/96/indianapolis/qualifying/0'   => '1950_indianapolis_500_qualifying_0.html',
    'en/results/1950/races/96/indianapolis/race-result'    => '1950_indianapolis_500_race_result.html',
    'en/results.html/1950/races'                           => '1950_races.html',

    'en/results/1984/races/466/brazil/fastest-laps'        => '1984_brazil_fastest_laps.html',
    'en/results/1984/races/466/brazil/qualifying/0'        => '1984_brazil_qualifying_0.html',
    'en/results/1984/races/466/brazil/qualifying/1'        => '1984_brazil_qualifying_1.html',
    'en/results/1984/races/466/brazil/qualifying/2'        => '1984_brazil_qualifying_2.html',
    'en/results/1984/races/466/brazil/race-result'         => '1984_brazil_race_result.html',
    'en/results/1984/races/466/brazil/starting-grid'       => '1984_brazil_starting_grid.html',
    'en/results/1984/races/466/brazil/practice/0'          => '1984_brazil_warm_up.html',
    'en/results/1984/races'                                => '1984_races.html',

    'en/results/2016/races/938/australia/fastest-laps'     => '2016_australia_fastest_laps.html',
    'en/results/2016/races/938/australia/pit-stop-summary' => '2016_australia_pit_stop_summary.html',
    'en/results/2016/races/938/australia/practice/1'       => '2016_australia_practice_1.html',
    'en/results/2016/races/938/australia/qualifying'       => '2016_australia_qualifying.html',
    'en/results/2016/races/938/australia/race-result'      => '2016_australia_race_result.html',
    'en/results/2016/races'                                => '2016_races.html',

    'en/results/2024/races/1242/belgium/race-result'       => '2024_belgium_race_result.html',
  }

  def before_setup
    super
    STUBS.each_key { |path| stub(path) }
  end

  private

    def fixture_path(file)
      File.join(FIXTURES_DIR, file)
    end

    def events(name)
      agent = Mechanize.new
      file = "#{name.to_s}.html"
      page = agent.get "file://#{fixture_path(file)}"
      event = F1Results::Parser.new(page).parse
      return event
    end

    # TODO: This doesn't work at all, requests are still being made to the remote server
    def stub(path)
      remote_uri = URI.join(F1Results::BASE_URL, path)
      fixture = STUBS[path]

      response = case
      when fixture.is_a?(Integer)
        { status: fixture }
      when fixture.is_a?(String)
        { status:  200,
          headers: { 'Content-Type' => 'text/html' },
          body:    File.read(fixture_path(fixture)) }
      end

      stub_request(:get, remote_uri.to_s).to_return(response)
    end
end
