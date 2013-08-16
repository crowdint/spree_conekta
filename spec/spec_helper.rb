ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment", __FILE__)

require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f }


RSpec.configure do |config|
  config.color = true

  # Capybara javascript drivers require transactional fixtures set to false, and we just use DatabaseCleaner to cleanup after each test instead.
  # Without transactional fixtures set to false none of the records created to setup a test will be available to the browser, which runs under a seperate server instance.
  config.use_transactional_fixtures = false
end
