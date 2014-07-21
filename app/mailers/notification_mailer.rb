class NotificationMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.new_answer.subject
  #
  def new_answer(answer_id)
    @answer = Answer.find(answer_id)
    @greeting = t('common.hello')
    @description = t('notification_mailer.new_answer.description',
      question: @answer.question.title)

    mail to: @answer.question.user.email, from: "no-reply@under.dev"
  end
end
