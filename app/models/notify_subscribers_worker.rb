class NotifySubscribersWorker
  include Sidekiq::Worker

  def perform(object_id)
    answer = Answer.find(object_id)
    question = Question.find(answer.question_id)
    question.subscribers.each do |subscriber|
      NotificationMailer.delay.new_answer(answer.id, subscriber.id)
    end
  end
end