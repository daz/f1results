require 'bundler/setup'
require 'rake'
require 'rake/testtask'
require './test/lib/fixtures'
require 'open-uri'

task default: :test

Rake::TestTask.new do |t|
  t.libs << 'test/lib'
  t.pattern = 'test/*_test.rb'
end

desc 'Download fixtures from formula1.com'
task :download_fixtures do
  include Fixtures
  WebMock.disable!

  STUBS.each do |array|
     uri, file_path = expand_stub_paths(Hash[*array]).to_a[0]
     next if file_path.is_a?(Integer)

     File.open(file_path, 'wb') do |fo|
       fo.write open(uri).read
     end
     puts "\033[0;32m✓\033[0m #{uri}"
  end
end
