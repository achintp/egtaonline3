ENV["RAILS_ENV"] ||= 'test'
# require 'simplecov'
# SimpleCov.start
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'database_cleaner'
require 'capybara/rspec'
require 'capybara/poltergeist'
require 'capybara/rails'
require 'sidekiq/testing/inline'
Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 15
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

Rails.logger.level = 4

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
  config.include(MailerMacros)
  config.include(SessionHelpers, type: :feature)

  config.before(:each) do
    reset_email
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation, {:pre_count => true}
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

SCHEDULER_CLASSES = [GameScheduler, DeviationScheduler, DprDeviationScheduler, DprScheduler, GenericScheduler, HierarchicalDeviationScheduler, HierarchicalScheduler]
NONGENERIC_SCHEDULER_CLASSES = SCHEDULER_CLASSES-[GenericScheduler]