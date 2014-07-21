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
  it { should have_many :subscriptions }
  it { should have_many :subscribers }
  it { should have_and_belong_to_many :tags }

  it { should accept_nested_attributes_for :attachments }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should ensure_length_of(:title).is_at_least(15).is_at_most(60) }
  it { should ensure_length_of(:body).is_at_least(60).is_at_most(6000) }

  it_behaves_like "voteable"
  it_behaves_like "favorable"
  it_behaves_like "timestampable"

  context 'when created' do
    subject { build(:question) }

    it { should be_active }
    it { should_not be_deleted }
  end

  describe 'self#favorited' do
    let(:user) { create(:user) }
    let(:question1) { create(:question) }
    let(:question2) { create(:question) }
    before { create(:favorite, favorable: question2, user: user)}

    it 'returns Questions favored by User' do
      expect(Question.favorited(user.id)).to match_array [question2]
    end
  end

  describe '#from?' do
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

  describe '#subscribe' do
    let(:user) { create(:user) }
    subject { create(:question) }

    it "returns subscription" do
      subscription = subject.subscribe(user)
      expect(subscription).to be_a Subscription
    end

    it 'subscribes user to Question' do
      subscription = subject.subscribe(user)
      expect(subscription.user).to eq(user)
    end

    it 'subscribes user to this Question' do
      subscription = subject.subscribe(user)
      expect(subscription.subscribable).to eq(subject)
    end
  end

  context 'scopes' do
    let!(:question1) { create(:question) }
    let!(:question2) { create(:question) }
    let!(:question3) { create(:question) }

    describe '#self.unanswered' do
      let!(:answer1) { create(:answer, question: question1) }

      it 'returns only Questions with Answers' do
        expect(Question.unanswered).to match_array [question3, question2]
      end
    end

    describe '#self.popular' do
      let!(:question1) { create(:question, views_count: 10) }
      let!(:question2) { create(:question, views_count: 20) }
      let!(:question3) { create(:question, views_count: 0) }

      it 'returns Questions ordered by views_count' do
        expect(Question.popular).to match_array [question2, question1, question3]
      end
    end

    describe '#self.featured' do
      before do
        create(:bounty, question: question1)
        create(:bounty, question: question2, winner: question1.user)
      end

      it 'returns Questions with unreceived Bounties' do
        expect(Question.featured).to match_array [question1]
      end
    end

    describe '#self.most_voted' do
      before do
        create(:vote, voteable: question1, value: -1)
        create_pair(:vote, voteable: question2, value: 1)
      end

      it 'returns Questions ordered by vote_sum' do
        expect(Question.most_voted).to match_array [question2, question3, question1]
      end
    end
  end
end