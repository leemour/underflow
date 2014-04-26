# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name "MyString"
    email "MyString"
    real_name "MyString"
    website "MyString"
    location "MyString"
    birthday "2014-04-26 18:18:10"
    about "MyText"
  end
end
