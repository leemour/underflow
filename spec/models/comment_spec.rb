require 'spec_helper'

describe Comment do
  it { should belong_to(:user) }
  it { should belong_to(:commentable) }

  it { should validate_presence_of(:body) }
  it { should ensure_length_of(:body).is_at_least(15).is_at_most(500) }

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
