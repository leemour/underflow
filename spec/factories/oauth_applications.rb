FactoryGirl.define do
  factory :oauth_application, class: Doorkeeper::Application do
    name          'Test'
    redirect_uri  'urn:ietf:wg:oauth:2.0:oob'
    sequence(:uid) { |n| 999 + n }
    secret        '123456789'
  end
end