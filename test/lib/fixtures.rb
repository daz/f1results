require 'f1results'
require 'webmock'
module Fixtures
  include ::WebMock::API

  FIXTURES_DIR = File.expand_path('../../fixtures', __FILE__)

  STUBS = {
    event_1900_404: {
      'en/results/1900/races'                                => 404
    },

    event_1950_indianapolis_fastest_laps: {
      'en/results/1950/races/96/indianapolis/fastest-laps'   => '1950-indianapolis-fastest-laps.html'
    },
    event_1950_indianapolis_qualifying_0: {
      'en/results/1950/races/96/indianapolis/qualifying/0'   => '1950-indianapolis-qualifying-0.html'
    },
    event_1950_indianapolis_race_result: {
      'en/results/1950/races/96/indianapolis/race-result'    => '1950-indianapolis-race-result.html'
    },
    event_1950_indianapolis_starting_grid: {
      'en/results/1950/races/96/indianapolis/starting-grid'  => '1950-indianapolis-starting-grid.html'
    },
    event_1950_races_all: {
      'en/results/1950/races'                                => '1950-race-results.html'
    },

    event_1984_brazil_fastest_laps: {
      'en/results/1984/races/466/brazil/fastest-laps'        => '1984-brazil-fastest-laps.html'
    },
    event_1984_brazil_qualifying_0: {
      'en/results/1984/races/466/brazil/qualifying/0'        => '1984-brazil-qualifying-0.html'
    },
    event_1984_brazil_qualifying_1: {
      'en/results/1984/races/466/brazil/qualifying/1'        => '1984-brazil-qualifying-1.html'
    },
    event_1984_brazil_qualifying_2: {
      'en/results/1984/races/466/brazil/qualifying/2'        => '1984-brazil-qualifying-2.html'
    },
    event_1984_brazil_race_result: {
      'en/results/1984/races/466/brazil/race-result'         => '1984-brazil-race-result.html'
    },
    event_1984_brazil_starting_grid: {
      'en/results/1984/races/466/brazil/starting-grid'       => '1984-brazil-starting-grid.html'
    },
    event_1984_brazil_practice_0: {
      'en/results/1984/races/466/brazil/practice/0'          => '1984-brazil-practice-0.html'
    },
    event_1984_races_all: {
      'en/results/1984/races'                                => '1984-race-results.html'
    },

    event_2016_australia_fastest_laps: {
      'en/results/2016/races/938/australia/fastest-laps'     => '2016-australia-fastest-laps.html'
    },
    event_2016_australia_pit_stop_summary: {
      'en/results/2016/races/938/australia/pit-stop-summary' => '2016-australia-pit-stop-summary.html'
    },
    event_2016_australia_practice_1: {
      'en/results/2016/races/938/australia/practice/1'       => '2016-australia-practice-1.html'
    },
    event_2016_australia_qualifying: {
      'en/results/2016/races/938/australia/qualifying'       => '2016-australia-qualifying.html'
    },
    event_2016_australia_race_result: {
      'en/results/2016/races/938/australia/race-result'      => '2016-australia-race-result.html'
    },
    event_2016_races_all: {
      'en/results/2016/races'                                => '2016-race-results.html'
    },

    event_2024_belgium_race_result: {
      'en/results/2024/races/1242/belgium/race-result'       => '2024-belgium-race-result.html'
    },
    event_2024_singapore_qualifying: {
      'en/results/2024/races/1246/singapore/qualifying'      => '2024-singapore-qualifying.html'
    },
  }

  private

    def fixture_path(file)
      File.join(FIXTURES_DIR, file)
    end

    def stub_all
      STUBS.each_key { |name| stub(name) }
    end

    def events(name)
      agent = Mechanize.new
      file = STUBS[name].values.first
      page = agent.get "file://#{fixture_path(file)}"
      event = F1Results::Parser.new(page).parse
      return event
    end

    # TODO: This doesn't work at all, requests are still being made to the remote server
    def stub(name)
      path = STUBS[name].keys.first
      return if path.nil?
      remote_uri = URI.join(F1Results::BASE_URL, path)
      fixture = STUBS[name][path]

      response = case
      when fixture.is_a?(Integer)
        { status: fixture }
      when fixture.is_a?(String)
        lambda do
          {
            status: 200,
            headers: { 'Content-Type' => 'text/html' },
            body: File.binread(fixture_path(fixture))
          }
        end
      end

      stub_request(:get, remote_uri.to_s).to_return(response)
    end
end
