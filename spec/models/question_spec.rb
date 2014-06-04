require 'spec_helper'

describe Question do
  it { should belong_to :user }
  it { should have_db_index :user_id }
  it { should have_one :bounty }
  it { should have_many :answers }
  it { should have_many :comments }
  it { should have_many :attachments }
  it { should have_many :votes }
  it { should have_many :favorites }
  it { should have_and_belong_to_many :tags }

  it { should accept_nested_attributes_for :attachments }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should ensure_length_of(:title).is_at_least(15).is_at_most(60) }
  it { should ensure_length_of(:body).is_at_least(60).is_at_most(6000) }

  context 'when created' do
    subject { build(:question) }

    it { should be_active }
    it { should_not be_deleted }
  end

  describe '#from?(user)' do
    let(:user) { create(:user) }

    it 'returns true when user is the author' do
      question = create(:question, user: user)
      expect(question).to be_from(user)
    end

    it 'returns false when user is not the author' do
      question = create(:question)
      expect(question).to_not be_from(user)
    end
  end

  describe '#tag_list' do
    subject { create(:question) }
    let!(:tags) { create_list(:tag, 3, questions: [subject]) }

    it "returns array of Question Tag names" do
      tag_names = tags.map(&:name)
      expect(subject.tag_list).to match_array(tag_names)
    end
  end

  describe '#tag_list=' do
    subject { create(:question) }
    let!(:tag) { create(:tag, name: 'tag1', questions: [subject]) }
    before { subject.reload }

    it "creates tag that doesn't exist" do
      expect {
        subject.update(tag_list: %w[tag1 tag2])
      }.to change(Tag, :count).by(1)
    end

    it "doesn't delete tags that exist" do
      expect {
        subject.update(tag_list: [])
      }.to_not change(Tag, :count)
    end

    it "doesnt' delete tags already associated with question" do
      expect {
        subject.update(tag_list: 'tag1')
      }.to_not change(subject.tags, :count)
    end

    it "keeps tags name already associated with question" do
      subject.update(tag_list: 'tag1')
      expect(subject.tags.first).to eq(tag)
    end

    it "adds new tags to question" do
      expect {
        subject.update(tag_list: %w[tag1 tag2])
      }.to change(subject.tags, :count).by(1)
    end

    it "removes already associated tags from question" do
      expect {
        subject.update(tag_list: [])
      }.to change(subject.tags, :count).by(-1)
    end
  end

  describe '#accepted_answer' do
    subject { create(:question) }

    it 'returns accepted answer if accepted' do
      answer = create(:answer, question: subject, accepted: true)
      expect(subject.accepted_answer).to eq(answer)
    end

    it 'returns nil if not accepted' do
      answer = create(:answer, question: subject)
      expect(subject.accepted_answer).to be_nil
    end
  end

  describe '#accepted?' do
    subject { create(:question) }

    it 'returns true if answer is accepted' do
      answer = create(:answer, question: subject, accepted: true)
      expect(subject.accepted?(answer)).to be_true
    end

    it 'returns true if answer is not accepted' do
      answer = create(:answer, question: subject)
      expect(subject.accepted?(answer)).to be_false
    end
  end

  describe '#vote_up' do
    subject { create(:question) }
    let(:user) { create(:user) }

    it 'returns a Vote' do
      expect(subject.vote_up(user)).to be_a(Vote)
    end

    it 'changes Question votes by +1' do
      expect {
        subject.vote_up(user)
      }.to change(subject.votes, :count).by(1)
    end

    it 'changes Question rating by +1' do
      expect {
        subject.vote_up(user)
      }.to change(subject, :vote_sum).by(1)
    end
  end

  describe '#vote_down' do
    subject { create(:question) }
    let(:user) { create(:user) }

    it 'returns a Vote' do
      expect(subject.vote_down(user)).to be_a(Vote)
    end

    it 'changes Question votes by -1' do
      expect {
        subject.vote_down(user)
      }.to change(subject.votes, :count).by(1)
    end

    it 'changes Question rating by -1' do
      expect {
        subject.vote_down(user)
      }.to change(subject, :vote_sum).by(-1)
    end
  end

  describe '#vote_sum' do
    subject { create(:question) }
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

  describe '#favor' do
    subject { create(:question) }
    let(:user) { create(:user) }

    it 'returns a Favorite' do
      expect(subject.favor(user)).to be_a(Favorite)
    end

    context 'if not favourite' do
      it 'adds Question to User favourites' do
        expect {
          subject.favor(user)
        }.to change(subject.favorites, :count).by(1)
      end
    end

    context 'if already favourite' do
      it 'removes Question from User favourites' do
        subject.favor(user)
        expect {
          subject.favor(user)
        }.to change(subject.favorites, :count).by(-1)
      end
    end
  end

  describe '#favored_by?' do
    subject { create(:question) }
    let(:user) { create(:user) }

    it 'returns false if User not favoured' do
      expect(subject.favored_by?(user)).to be_false
    end

    it 'returns true if User favoured' do
      subject.favor(user)
      expect(subject.favored_by?(user)).to be_true
    end
  end
end