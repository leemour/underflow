namespace :counters do
  desc "Update Answer cache counter for all Questions"
  task question_answers: :environment do
    Question.find_each do |q|
      Question.reset_counters(q.id, :answers)
    end
  end

  # desc "Update Answer cache counter for all Questions"
  # task tag_questions: :environment do
  #   Tag.find_each do |t|
  #     Tag.reset_counters(t.id, :questions)
  #   end
  # end
end