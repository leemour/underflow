FactoryBot.define do
  factory :authorization do
    user     { nil }
    provider { "facebook" }
    uid      { "MyString" }
  end
end
