require "spec_helper"

describe NotificationMailer do
  describe "#new_answer" do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }
    let(:mail) { NotificationMailer.new_answer(answer.id, user.id) }

    context 'headers' do
      it "renders subject" do
        expect(mail.subject).to eq(
          I18n.t('notification_mailer.new_answer.subject'))
      end
      it "renders from" do
        expect(mail.from).to eq(["no-reply@under.dev"])
      end
      it "renders to" do
        expect(mail.to).to eq([user.email])
      end
    end

    context "body" do
      it "renders greeting" do
        expect(mail.body.encoded).to match(I18n.t('common.hello'))
      end

      it "renders description" do
        expect(mail.body.encoded).to match(
          I18n.t('notification_mailer.new_answer.description',
            question: answer.question.title))
      end

      it "renders answer question link" do
        expect(mail.body.encoded).to have_link(answer.question.title)
      end
    end
  end

end
