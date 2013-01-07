require File.expand_path('../lib/f1results/version', __FILE__)

Gem::Specification.new do |s|
  s.author        = 'Darren Jeacocke'
  s.email         = 'dazonic@me.com'
  s.description   = 'Get F1 results from formula1.com'
  s.summary       = 'F1 Results'

  s.files         = Dir['bin/f1results', 'lib/**/*', 'test/*', 'Rakefile', 'README.md', 'LICENSE']
  s.executables   = ['f1results']
  s.name          = 'f1results'
  s.require_paths = ['lib']
  s.version       = F1Results::VERSION
  s.add_dependency 'mechanize'
  s.add_dependency 'terminal-table'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'webmock'
end
