FactoryGirl.define do
  factory :vote do
    voteable    nil
    user        nil
    value       { [1, -1].sample }
  end
end