require 'spec_helper'

RSpec.configure do |config|
  Capybara.javascript_driver = :webkit
  OmniAuth.config.test_mode = true

  config.include Acceptance::SessionHelpers, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    FactoryGirl.lint
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.after(:all) do
    # Get rid of the attachments
    if Rails.env.test? || Rails.env.cucumber?
      FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads/attachment/test"])
      # if you want to delete everything under the CarrierWave root that you set in an initializer,
      # you can do this:
      # FileUtils.rm_rf(CarrierWave::Uploader::Base.root)
    end
  end
end