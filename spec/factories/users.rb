# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "user#{n}" }
    sequence(:email) { |n| "email#{n}@gmail.com" }
    password              '12345678'
    password_confirmation '12345678'

    factory :user_with_profile do
      ignore do
        profile Hash.new
      end

      after(:create) do |user, evaluator|
        profile = evaluator.profile || {}
        user.profile.update(profile)
      end
    end
  end
end
