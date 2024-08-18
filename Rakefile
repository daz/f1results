require "bundler/setup"
require "rake"
require "rake/testtask"
require "./test/lib/fixtures"
require "open-uri"
require "fileutils"

task default: :test

Rake::TestTask.new do |t|
  t.libs << "test/lib"
  t.pattern = "test/*_test.rb"
  t.warning = false
end

desc "Download fixtures from formula1.com"
task :download_fixtures do
  include Fixtures
  WebMock.disable!

  STUBS.each_key do |path|
    remote_uri = File.join(F1Results::BASE_URL, path)
    fixture = STUBS[path]
    next if fixture.is_a?(Integer)

    puts "Downloading #{remote_uri} => #{fixture}"

    URI.open(remote_uri) do |remote_file|
      File.open(fixture_path(fixture), "w") { |local_file| local_file.write(remote_file.read) }
    end
  end
end
