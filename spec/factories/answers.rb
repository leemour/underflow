# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :answer do
    user
    question
    accepted false
    body      "To be, or not to be, that is the question—
      Whether 'tis Nobler in the mind to suffer
      The Slings and Arrows of outrageous Fortune,
      Or to take Arms against a Sea of troubles,
      And by opposing end them?"

    after(:build) do |answer|
      answer.class.skip_callback(:create, :after, :notify_question_subscribers)
    end
  end
end
