lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'f1results/version'

Gem::Specification.new do |s|
  s.author        = 'Darren Jeacocke'
  s.email         = 'dazonic@me.com'
  s.description   = 'Get F1 results from formula1.com'
  s.summary       = 'F1 Results'
  s.homepage      = 'https://github.com/daz/f1results'
  s.license       = 'MIT'

  s.files         = Dir['bin/f1results', 'lib/**/*', 'test/*', 'Rakefile', 'README.md', 'LICENSE']
  s.executables   = ['f1results']
  s.name          = 'f1results'
  s.require_paths = ['lib']
  s.version       = F1Results::VERSION
  s.add_runtime_dependency 'mechanize', '~> 2.14'
  s.add_runtime_dependency 'terminal-table', '~> 4.0'

  s.add_development_dependency 'rake', '~> 13.3'
  s.add_development_dependency 'minitest', '~> 5.25'
  s.add_development_dependency 'webmock', '~> 3.25.1'
end
