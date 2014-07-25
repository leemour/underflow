require 'spec_helper'

describe NotifySubscribersWorker do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:subscriber) { create(:user) }
  let!(:subscription) { create(:subscription, user: subscriber,
    subscribable: question) }

  it "sends notification to all subscribers" do
    expect(NotificationMailer).to receive(:new_answer).with(answer.id, question.user.id)
    expect(NotificationMailer).to receive(:new_answer).with(answer.id, subscriber.id)
    subject.perform(answer.id)
  end
end