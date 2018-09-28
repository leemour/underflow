FactoryBot.define do
  factory :question do
    user
    title   { "To be or not to be" }
    body  {
      <<~BODY
        But that the dread of something after death,
        The undiscover'd country from whose bourn
        No traveller returns, puzzles the will
        And makes us rather bear those ills we have
        Than fly to others that we know not of?
        Thus conscience does make cowards of us all"
      BODY
    }
    transient do
      tag_names { [] }
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
