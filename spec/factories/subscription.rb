FactoryBot.define do
  factory :subscription do
    subscribable { nil }
    user
  end
end
