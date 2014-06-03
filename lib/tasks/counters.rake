namespace :counters do
  desc "Update Answer cache counter for all Questions"
  task question_answers: :environment do
    Question.find_each do |q|
      Question.reset_counters(q.id, :answers)
    end
  end
end