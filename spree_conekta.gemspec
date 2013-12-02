$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'spree_conekta/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'spree_conekta'
  s.version     = SpreeConekta::VERSION
  s.authors     = ['Jonathan Garay', 'Fernando Barajas']
  s.email       = %w(jonathan.garay@crowdint.com fernando.barajas@crowdint.com)
  s.homepage    = 'http://github.com/crowdint/spree_conekta'
  s.summary     = 'Spree Engine for Conekta Mexican Payment gateway'
  s.description = 'Spree Engine for Conekta Mexican Payment gateway'

  s.files = Dir['{app,config,models,db,lib}/**/*'] + %w(MIT-LICENSE Rakefile README.md)

  s.add_dependency 'spree', '~> 2.1'

  s.add_dependency 'oj'
  s.add_dependency 'faraday'
  s.add_dependency 'typhoeus'
  s.add_dependency 'faraday_middleware'
  s.add_dependency 'activemerchant'

  s.add_development_dependency 'rspec-rails', '~> 2.13'
  s.add_development_dependency 'debugger'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'faker'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'spork'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'capybara-webkit'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'vcr'

end
