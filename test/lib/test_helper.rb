require 'f1results'
require 'minitest/autorun'
require 'webmock'
require 'minitest/assertions'

module Fixtures
  include WebMock::API

  def before_setup
    super
    override_requests
  end

  private

    def events(name)
      @agent ||= F1Results::Agent.new
      file = "#{name.to_s.gsub('_', '-')}.html"
      @agent.get_results_with_url fixture_url(file)
    end

    def override_requests
      stub 'results.html/1900/races.html'                                  => 404

      stub 'results.html/1950/races/96/indianapolis-500/fastest-laps.html' => '1950-indianapolis-500-fastest-laps.html'
      stub 'results.html/1950/races/96/indianapolis-500/qualifying-0.html' => '1950-indianapolis-500-qualifying-0.html'
      stub 'results.html/1950/races/96/indianapolis-500/race-result.html'  => '1950-indianapolis-500-race-result.html'
      stub 'results.html/1950/races.html'                                  => '1950-races.html'

      stub 'results.html/1984/brazil/466/fastest-laps.html'                => '1984-brazil-fastest-laps.html'
      stub 'results.html/1984/brazil/466/qualifying-0.html'                => '1984-brazil-qualifying-0.html'
      stub 'results.html/1984/brazil/466/qualifying-1.html'                => '1984-brazil-qualifying-1.html'
      stub 'results.html/1984/brazil/466/qualifying-2.html'                => '1984-brazil-qualifying-2.html'
      stub 'results.html/1984/brazil/466/race-result.html'                 => '1984-brazil-race-result.html'
      stub 'results.html/1984/brazil/466/starting-grid.html'               => '1984-brazil-starting-grid.html'
      stub 'results.html/1984/brazil/466/warm-up.html'                     => '1984-brazil-warm-up.html'
      stub 'results.html/1984/races.html'                                  => '1984-races.html'

      stub 'results.html/2016/races/938/australia/fastest-laps.html'       => '2016-australia-fastest-laps.html'
      stub 'results.html/2016/races/938/australia/pit-stop-summary.html'   => '2016-australia-pit-stop-summary.html'
      stub 'results.html/2016/races/938/australia/practice-1.html'         => '2016-australia-practice-1.html'
      stub 'results.html/2016/races/938/australia/qualifying.html'         => '2016-australia-qualifying.html'
      stub 'results.html/2016/races/938/australia/race-result.html'        => '2016-australia-race-result.html'
      stub 'results.html/2016/races.html'                                  => '2016-races.html'
    end

    def stub(hash)
      path, fixture = hash.to_a[0]
      uri = File.join(F1Results::BASE_URL, path)

      response = case
      when fixture.is_a?(Integer)
        { status: fixture }
      when fixture.is_a?(String)
        { status:  200,
          headers: { 'Content-Type' => 'text/html' },
          body:    File.read(fixture_path(fixture)) }
      end

      stub_request(:get, uri).to_return(response)
    end

    def fixture_path(file)
      File.join File.expand_path(File.dirname(__FILE__)), '..', 'fixtures', file
    end

    def fixture_url(file)
      "file://#{fixture_path(file)}"
    end
end

module Minitest::Assertions
  def assert_nothing_raised(*)
    yield
  end

  def assert_raise_with_message(e, message, &block)
    e = assert_raises(e, &block)
    if message.is_a?(Regexp)
      assert_match(message, e.message)
    else
      assert_equal(message, e.message)
    end
  end
end
