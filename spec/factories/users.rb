# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name        "MyString"
    email       "test@gmail.com"
    password              '12345678'
    password_confirmation '12345678'
    real_name   "MyString"
    website     "http://underflow.com"
    location    "Moscow"
    birthday    "2014-04-26 18:18:10"
    about       "MyText"
  end
end
