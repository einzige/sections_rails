require 'rubygems'
require 'bundler/setup'
require 'rails'
require 'rspec'
require 'rspec-rails'

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"
#Rails = Hashie::Mash.new({:env => 'test'})

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }


RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
#  config.use_transactional_fixtures = true
end
