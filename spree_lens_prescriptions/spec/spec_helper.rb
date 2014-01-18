require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'
Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # Configure Rails Environment
  ENV['RAILS_ENV'] = 'test'

  require File.expand_path('../dummy/config/environment.rb',  __FILE__)

  require 'rspec/rails'
  require 'ffaker'
  require 'database_cleaner'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

  # Requires factories defined in spree_core
  require 'spree/core/testing_support/factories'
  require 'spree/core/testing_support/controller_requests'
  require 'spree/core/testing_support/authorization_helpers'
  require 'spree/core/url_helpers'
  require 'shoulda'

  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods

    # == URL Helpers
    #
    # Allows access to Spree's routes in specs:
    #
    # visit spree.admin_path
    # current_path.should eql(spree.products_path)
    config.include Spree::Core::UrlHelpers

    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = false

    config.before :suite do
      DatabaseCleaner.clean_with :truncation
    end
    config.before :each do
      DatabaseCleaner.strategy = :transaction
    end
    config.before(:each, js: true) do
      DatabaseCleaner.strategy = :truncation
    end
    config.before :each do
      DatabaseCleaner.start
    end
    config.after :each do
      DatabaseCleaner.clean
    end
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  FactoryGirl.reload
end
