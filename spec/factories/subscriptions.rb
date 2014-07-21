# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription, :class => 'Subscriptions' do
    subscribable nil
    user nil
  end
end
