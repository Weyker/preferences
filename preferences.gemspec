$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'preferences/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'preferences'
  s.version     = Preferences::VERSION
  s.authors     = ['Patricio Beckmann']
  s.email       = ['pato.beckmann@gmail.com']
  s.license     = 'MIT'

  s.summary     = 'Abstraction of Spree Preferences'
  s.homepage    = 'https://github.com/weyker/preferences'
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 2.1.0'

  s.add_dependency('railties', '>= 4.1.0', '< 6.0')
end
