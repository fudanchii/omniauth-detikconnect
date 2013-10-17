# -*- encoding: utf-8 -*-
require File.expand_path('../lib/omniauth-detikconnect/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_dependency 'omniauth', '~> 1.0'
  gem.add_dependency 'omniauth-oauth2'

  gem.add_development_dependency 'rspec', '~> 2.7'
  gem.add_development_dependency 'rack-test'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'simplecov'

  gem.authors       = ["Nurahmadie"]
  gem.email         = ["nurahmadie@detik.com"]
  gem.description   = %q{OmniAuth OAuth2 strategy for DetikConnect.}
  gem.summary       = %q{OmniAuth OAuth2 strategy for DetikConnect.}
  gem.homepage      = "https://github.com/fudanchii/omniauth-detikconnect"
  gem.license       = "MIT"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniauth-detikconnect"
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::DetikConnect::VERSION
end
