require 'f1results'
require 'minitest/autorun'
require 'webmock'

module Fixtures
  include WebMock::API

  def before_setup
    super
    override_requests
  end

  def override_requests
    stub 'results/season/1992/'          => '1992.html'
    stub 'results/season/1992/193/'      => '1992_hungary.html'
    stub 'results/season/2005/'          => '2005.html'
    stub 'results/season/2005/732/'      => '2005_australia.html'
    stub 'results/season/2005/732/6112/' => '2005_australia_saturday_qualifying.html'
    stub 'results/season/2005/732/6111/' => '2005_australia_sunday_qualifying.html'
    stub 'results/season/2012/'          => '2012.html'
    stub 'results/season/2012/872/'      => '2012_great_britain.html'
    stub 'results/season/2012/872/7148/' => '2012_great_britain_qualifying.html'
    stub 'results/season/2012/874/'      => '2012_hungary.html'
    stub 'results/season/1800/'          => 404
  end

  private

  def stub(hash)
    hash = hash.first
    uri = File.join(F1Results::BASEURL, hash[0])
    fixture = hash[1]

    request = case
    when fixture.is_a?(Integer)
      { :status => fixture }
    when fixture.is_a?(String)
      { :status => 200,
        :headers => { 'Content-Type' => 'text/html' },
        :body => File.read("#{File.dirname(__FILE__)}/../fixtures/#{fixture}") }
    end

    stub_request(:get, uri).to_return(request)
  end
end
