# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    user nil
    question nil
    body "MyText"
  end
end
