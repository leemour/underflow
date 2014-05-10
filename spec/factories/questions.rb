# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    user
    title   "To be or not to be"
    body    "To be, or not to be, that is the question—
      Whether 'tis Nobler in the mind to suffer
      The Slings and Arrows of outrageous Fortune,
      Or to take Arms against a Sea of troubles,
      And by opposing end them?"

    ignore do
      tag_names   []
    end
    factory :question_with_tags do
      after(:create) do |question, evaluator|
        evaluator.tag_names.each do |name|
          create(:tag, name: name, questions: [question])
        end
      end
    end
  end
end
