module MailerMacros
  def last_email
    ActionMailer::Base.deliveries.last
  end

  def confirmation_token(email)
    email.body.match(/confirmation_token=(\w)/)[1]
  end
end