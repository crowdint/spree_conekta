$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "spree_conekta/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "spree_conekta"
  s.version     = SpreeConekta::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of SpreeConekta."
  s.description = "TODO: Description of SpreeConekta."

  s.files = Dir["{app,config,models,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]


  s.add_dependency 'spree_core', '~> 2.0'
  s.add_dependency 'oj'
  s.add_dependency 'faraday'
  s.add_dependency 'typhoeus'
  s.add_dependency 'faraday_middleware'
  s.add_dependency 'activemerchant'

  s.add_development_dependency 'rspec-rails', '~> 2.13'
  s.add_development_dependency 'debugger'
  s.add_development_dependency 'sqlite3'

end
