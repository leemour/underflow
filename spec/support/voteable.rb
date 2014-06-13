shared_examples "voteable" do
  let(:subject_class) { described_class.name.underscore }

  describe '#vote_up' do
    subject { create(subject_class) }
    let(:user) { create(:user) }

    it 'returns a Vote' do
      expect(subject.vote_up(user)).to be_a(Vote)
    end

    context 'if not voted previously' do
      it 'changes Object votes by +1' do
        expect {
          subject.vote_up(user)
        }.to change(subject.votes, :count).by(1)
      end

      it 'changes Object vote_sum by +1' do
        expect {
          subject.vote_up(user)
        }.to change(subject, :vote_sum).by(1)
      end
    end

    context 'if upvoted already' do
      before { subject.vote_up(user) }

      it 'deletes Object Vote' do
        expect {
          subject.vote_up(user)
        }.to change(subject.votes, :count).by(-1)
      end

      it 'changes Object vote_sum by -1' do
        expect {
          subject.vote_up(user)
        }.to change(subject, :vote_sum).by(-1)
      end
    end

    context 'if downvoted already' do
      before { subject.vote_down(user) }

      it 'changes Object vote_sum by +2' do
        expect {
          subject.vote_up(user)
        }.to change(subject, :vote_sum).by(2)
      end
    end
  end

  describe '#vote_down' do
    subject { create(subject_class) }
    let(:user) { create(:user) }

    context 'if not voted previously' do
      it 'returns a Vote' do
        expect(subject.vote_down(user)).to be_a(Vote)
      end

      it 'changes Object votes by -1' do
        expect {
          subject.vote_down(user)
        }.to change(subject.votes, :count).by(1)
      end

      it 'changes Object vote_sum by -1' do
        expect {
          subject.vote_down(user)
        }.to change(subject, :vote_sum).by(-1)
      end
    end

    context 'if downvoted already' do
      before { subject.vote_down(user) }

      it 'deletes Object Vote' do
        expect {
          subject.vote_down(user)
        }.to change(subject.votes, :count).by(-1)
      end

      it 'changes Object vote_sum by +1' do
        expect {
          subject.vote_down(user)
        }.to change(subject, :vote_sum).by(1)
      end
    end

    context 'if upvoted already' do
      before { subject.vote_up(user) }

      it 'changes Object vote_sum by -2' do
        expect {
          subject.vote_down(user)
        }.to change(subject, :vote_sum).by(-2)
      end
    end
  end

  describe '#vote_sum' do
    subject { create(subject_class) }
    let(:user) { create(:user) }

    it 'returns 0 when no votes' do
      expect(subject.vote_sum).to eq(0)
    end

    it 'returns 1 when 1 upvote' do
      subject.vote_up(user)
      expect(subject.vote_sum).to eq(1)
    end

    it 'returns 1 when 1 downvote' do
      subject.vote_down(user)
      expect(subject.vote_sum).to eq(-1)
    end

    it 'returns 1 when 1 downvote and 2 upvotes' do
      subject.vote_down(user)
      subject.vote_up(create(:user))
      subject.vote_up(create(:user))
      expect(subject.vote_sum).to eq(1)
    end
  end


  describe 'scopes' do
    let!(:subject1) { create(subject_class) }
    let!(:subject2) { create(subject_class) }
    let!(:subject3) { create(subject_class) }

    describe '#self.voted_by' do
      let(:user1) { create(:user)}
      let(:user2) { create(:user)}
      before do
        create(:vote, voteable: subject1, user: user1)
        create(:vote, voteable: subject2, user: user2)
        create(:vote, voteable: subject3, user: user1)
      end

      it 'returns Objects voted by particular User' do
        expect(described_class.voted_by(user1.id)).
          to match_array [subject1, subject3]
      end
    end
  end
end