# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do |f|
    sequence(:name)  { |n| "user#{n}" }
    sequence(:email) { |n| "email#{n}@gmail.com" }
    password              '12345678'
    password_confirmation '12345678'

    after(:create) { |user| user.confirm! }
  end
end
