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
    expect(user.profile).to be_persisted
  end

  # describe '#voted_for?' do
  #   subject { create(:user) }

  #   context 'Question' do
  #     let(:question) { create(:question) }

  #     it 'returns true if User voted for it' do
  #       question.vote_up(subject)
  #       expect(subject.voted_for?(question)).to be_true
  #     end

  #     it "returns false if User didn't vote for it" do
  #       expect(subject.voted_for?(question)).to be_false
  #     end
  #   end

  #   context 'Answer' do
  #     let(:answer) { create(:answer) }

  #     it 'returns true if User voted for it' do
  #       answer.vote_up(subject)
  #       expect(subject.voted_for?(answer)).to be_true
  #     end

  #     it "returns false if User didn't vote for it" do
  #       expect(subject.voted_for?(answer)).to be_false
  #     end
  #   end
  # end

  describe '#get_vote_for' do
    subject { create(:user) }

    context 'Question' do
      let(:question) { create(:question) }

      it 'returns Vote' do
        question.vote_up(subject)
        expect(subject.get_vote_for(question)).to be_a(Vote)
      end

      it 'has value 1 when voted' do
         question.vote_up(subject)
        expect(subject.get_vote_for(question).value).to be(1)
      end
    end
  end

  describe '#voted' do
    subject { create(:user) }
    let(:question) { create(:question) }

    it 'returns :up if User voted object' do
      question.vote_up(subject)
      expect(subject.voted(question)).to eq(:up)
    end

    it 'returns :down if User downvoted object' do
      question.vote_down(subject)
      expect(subject.voted(question)).to eq(:down)
    end

    it "returns nil if User didn't vote for object" do
      expect(subject.voted(question)).to be_nil
    end
  end
end
