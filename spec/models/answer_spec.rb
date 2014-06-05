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
end
