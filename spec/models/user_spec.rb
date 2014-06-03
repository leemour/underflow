require 'spec_helper'

describe User do
  it { should have_one :profile }
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :comments }
  it { should have_many :favorites }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }
  it { should ensure_length_of(:name).is_at_least(3).is_at_most(30) }
  it { should allow_value('123@mail.ru').for(:email) }
  it do
    should_not allow_value(
      '01.01-2013',
      '@mail.ru',
      '1@mail.',
      '1.mail.ru',
      '12@.ru'
    ).for(:email)
  end

  it "has profile when created" do
    user = User.create!(email: '123@mai.ru', password: '12345678', name: 'hey')
    # expect(user.profile.id).to_not eq(nil)
    expect(user.profile).to be_persisted
  end

  describe '#voted_for?' do
    subject { create(:user) }

    context 'Question' do
      let(:question) { create(:question) }

      it 'returns true if User voted for it' do
        question.vote_up(subject)
        expect(subject.voted_for?(question)).to be_true
      end

      it "returns false if User didn't vote for it" do
        expect(subject.voted_for?(question)).to be_false
      end
    end

    context 'Answer' do
      let(:answer) { create(:answer) }

      it 'returns true if User voted for it' do
        answer.vote_up(subject)
        expect(subject.voted_for?(answer)).to be_true
      end

      it "returns false if User didn't vote for it" do
        expect(subject.voted_for?(answer)).to be_false
      end
    end
  end

  describe '#vote' do
    subject { create(:user) }

    context 'Question' do
      let(:question) { create(:question) }

      it 'returns Vote' do
        question.vote_up(subject)
        expect(subject.vote(question)).to be_a(Vote)
      end

      it 'has value 1 when upvoted' do
         question.vote_up(subject)
        expect(subject.vote(question).value).to be(1)
      end
    end
  end

  describe '#upvoted?' do
    subject { create(:user) }
    let(:question) { create(:question) }

    it 'returns true if User upvoted it' do
      question.vote_up(subject)
      expect(subject.upvoted?(question)).to be_true
    end

    it 'returns false if User downvoted it' do
       question.vote_down(subject)
      expect(subject.upvoted?(question)).to be_false
    end
  end

  describe '#downvoted?' do
    subject { create(:user) }
    let(:answer) { create(:answer) }

    it 'returns true if User upvoted it' do
      answer.vote_down(subject)
      expect(subject.downvoted?(answer)).to be_true
    end

    it 'returns false if User downvoted it' do
      answer.vote_up(subject)
      expect(subject.downvoted?(answer)).to be_false
    end
  end
end
