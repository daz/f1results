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

    def override_requests
      stub 'content/fom-website/en/championship/results/2015-race-results/2015-australia-results/qualifying.html' => '2015_australia_qualifying.html'
      stub 'content/fom-website/en/championship/results/2015-race-results/2015-australia-results/practice-1.html' => '2015_australia_p1.html'
      stub 'content/fom-website/en/championship/results/2015-race-results/2015-australia-results/race.html'       => '2015_australia_race.html'
      stub 'content/fom-website/en/championship/results/2015-race-results/2015-malaysia-results/practice-2.html'  => '2015_malaysia_p2.html'
      stub 'content/fom-website/en/championship/results/2015-race-results/2015-Hungary-results/race.html'         => '2015_hungary_race.html'
      stub 'content/fom-website/en/championship/results/2015-race-results/2015-new-zealand-results/race.html'     => 404
      stub 'content/fom-website/en/championship/results/2015-race-results/2015-New-Zealand-results/race.html'     => 404
      stub 'content/fom-website/en/championship/results/1900-race-results/1900-Australia-results/race.html'       => 404
      stub 'content/fom-website/en/championship/results/1900-race-results/1900-australia-results/race.html'       => 404
    end

    def stub(hash)
      hash = hash.first
      uri = File.join(F1Results::BASEURL, hash[0])
      fixture = hash[1]

      response = case
      when fixture.is_a?(Integer)
        { status: fixture }
      when fixture.is_a?(String)
        { status:  200,
          headers: { 'Content-Type' => 'text/html' },
          body:    File.read("#{File.dirname(__FILE__)}/../fixtures/#{fixture}") }
      end

      stub_request(:get, uri).to_return(response)
    end
end

module Minitest::Assertions
  def assert_nothing_raised(*)
    yield
  end
end
