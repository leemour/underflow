# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tag do
    questions []
    sequence(:name) {|n| "tag#{n}" }
    excerpt     "To be, or not to be, that is the question—
      Whether 'tis Nobler in the mind to suffer
      The Slings and Arrows of outrageous Fortune"
    description  "To be, or not to be, that is the question—
      Whether 'tis Nobler in the mind to suffer
      The Slings and Arrows of outrageous Fortune,
      Or to take Arms against a Sea of troubles,
      And by opposing end them?"
  end
end
