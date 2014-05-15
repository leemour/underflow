# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Maintains test DB migrations in sync with development
ActiveRecord::Migration.maintain_test_schema!

DatabaseCleaner.strategy = :transaction

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include Capybara::DSL
  config.include Devise::TestHelpers, type: :controller
  config.include Devise::TestHelpers, type: :view
  config.include ControllerMacros, type: :controller

  # config.formatter = :documentation # :progress, :html, :textmate
  # config.color_enabled = true
  # Use color not only in STDOUT but also in pagers and files
  # config.tty = true
  config.order = "random"
  config.use_transactional_fixtures = true
end
