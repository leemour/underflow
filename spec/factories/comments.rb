FactoryBot.define do
  factory :comment do
    user
    commentable { nil }
    body        { "Lorem ipsum dolor sit amet lorum" }

    factory :question_comment do
      association :commentable, factory: :question
    end

    factory :answer_comment do
      association :commentable, factory: :answer
    end
  end
end
