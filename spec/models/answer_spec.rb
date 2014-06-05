require 'spec_helper'

describe Answer do
  it { should belong_to :user }
  it { should have_db_index :user_id }
  it { should belong_to :question }
  it { should have_db_index :question_id }
  it { should have_one :bounty }
  it { should have_many :comments }
  it { should have_many :attachments }

  it { should accept_nested_attributes_for :attachments }

  it { should validate_presence_of(:body) }
  it { should ensure_length_of(:body).is_at_least(30).is_at_most(6000) }

  describe '#from?(user)' do
    let(:user) { create(:user) }

    it 'returns true when user is the author' do
      answer = create(:answer, user: user)
      expect(answer).to be_from(user)
    end

    it 'returns false when user is not the author' do
      answer = create(:answer)
      expect(answer).to_not be_from(user)
    end
  end

  describe '#toggle_bounty_from' do
    let(:question) { create(:question) }
    let(:answer)   { create(:answer, question: question) }
    let!(:bounty)  { create(:bounty, question: question) }

    context 'when not received Bounty' do
      it "adds Answer to Bounty as winner" do
        answer.toggle_bounty_from question
        expect(bounty.winner).to eq(answer.user)
      end

      it "adds Bounty value to user reputation" do
        expect {
          answer.toggle_bounty_from question
        }.to change(answer.user, :reputation).by(bounty.value)
      end
    end

    context 'when already received Bounty' do
      before { answer.toggle_bounty_from question }

      it "removes Answer from Bounty winner" do
        answer.toggle_bounty_from question
        expect(bounty.winner).to be_nil
      end

      it "adds Bounty value to user reputation" do
        expect {
          answer.toggle_bounty_from question
        }.to change(answer.user, :reputation).by(-bounty.value)
      end
    end
  end
end
