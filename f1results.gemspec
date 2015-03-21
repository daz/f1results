lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'f1results/version'

Gem::Specification.new do |s|
  s.author        = 'Darren Jeacocke'
  s.email         = 'dazonic@me.com'
  s.description   = 'Get F1 results from formula1.com'
  s.summary       = 'F1 Results'
  s.homepage      = 'https://github.com/daz/f1results'

  s.files         = Dir['bin/f1results', 'lib/**/*', 'test/*', 'Rakefile', 'README.md', 'LICENSE']
  s.executables   = ['f1results']
  s.name          = 'f1results'
  s.require_paths = ['lib']
  s.version       = F1Results::VERSION
  s.add_dependency 'mechanize', '~> 2.7'
  s.add_dependency 'terminal-table', '~> 1.4.5'
  s.add_dependency 'activesupport'

  s.add_development_dependency 'rake', '~> 10.1'
  s.add_development_dependency 'minitest', '~> 5.3'
  s.add_development_dependency 'webmock', '~> 1.17'
end
