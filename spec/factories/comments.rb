# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    user
    commentable nil
    body  "To be, or not to be, that is the question"
  end
end
