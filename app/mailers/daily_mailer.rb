class DailyMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_mailer.daily_digest.subject
  #
  def digest(user_id)
    @user = User.find(user_id)
    @greeting = t('common.hello')
    @description = t('daily_mailer.digest.description')
    @questions = Question.where('created_at > ?', 1.day.ago)

    mail to: @user.email, from: 'no-reply@under.dev'
  end
end
