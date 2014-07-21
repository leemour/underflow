require "spec_helper"

describe DailyMailer do
  describe "#digest" do
    let(:user) { create(:user) }
    let(:mail) { DailyMailer.digest(user.id) }

    context 'headers' do
      it "renders subject" do
        expect(mail.subject).to eq(I18n.t('daily_mailer.digest.subject'))
      end
      it "renders from" do
        expect(mail.from).to eq(["no-reply@under.dev"])
      end
      it "renders to" do
        expect(mail.to).to eq([user.email])
      end
    end

    context "body" do
      let!(:new_question) { create(:question, title: 'This is new question') }
      let!(:old_question) { create(:question, created_at: 2.days.ago) }

      it "renders greeting" do
        expect(mail.body.encoded).to match(I18n.t('common.hello'))
      end

      it "renders description" do
        expect(mail.body.encoded).to match(
          I18n.t('daily_mailer.digest.description'))
      end

      it "renders questions created within 24 hours" do
        expect(mail.body.encoded).to have_link(new_question.title)
      end

      it "doesn't render questions older than 24 hours" do
        expect(mail.body.encoded).to_not have_link(old_question.title)
      end
    end
  end

end
