FactoryGirl.define do
  factory :profile do
    user        nil
    real_name   "MyString"
    website     "http://underflow.com"
    location    "Moscow"
    birthday    "2014-04-26 18:18:10"
    about       "MyText"
  end
end