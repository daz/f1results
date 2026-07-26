require "bundler/setup"
require "rake"
require "rake/testtask"
require "./test/lib/fixtures"
require "open-uri"
require "fileutils"
require "tempfile"

task default: :test

Rake::TestTask.new do |t|
  t.libs << "test/lib"
  t.pattern = "test/*_test.rb"
  t.warning = false
end

def fixture_downloads
  Fixtures::STUBS.flat_map do |_name, mappings|
    mappings.filter_map do |path, fixture|
      next if fixture.is_a?(Integer)

      {
        url: URI.join(F1Results::BASE_URL, path).to_s,
        destination: File.join(Fixtures::FIXTURES_DIR, fixture)
      }
    end
  end
end

namespace :fixtures do
  desc "List fixture URLs and destinations without downloading them"
  task :list do
    fixture_downloads.each do |download|
      puts "#{download[:url]} => #{download[:destination]}"
    end
  end

  desc "Download fixtures from formula1.com"
  task :download do
    WebMock.disable!
    FileUtils.mkdir_p(Fixtures::FIXTURES_DIR)

    fixture_downloads.each do |download|
      puts "Downloading #{download[:url]} => #{download[:destination]}"

      Tempfile.create(["f1results-fixture-", ".html"], Fixtures::FIXTURES_DIR) do |temporary|
        URI.open(download[:url]) do |remote_file|
          IO.copy_stream(remote_file, temporary)
        end
        temporary.close
        FileUtils.mv(temporary.path, download[:destination])
      end
    end
  end
end

desc "Download fixtures from formula1.com (alias for fixtures:download)"
task download_fixtures: "fixtures:download"
