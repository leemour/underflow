require 'spec_helper'

describe User do
  it { should have_one :profile }
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :comments }
  it { should have_many :favorites }
  it { should have_many :authorizations }

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

  describe '#find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth_params) { {provider: 'facebook', uid: '123456'} }
    let(:auth) { OmniAuth::AuthHash.new auth_params }

    context "user already has authorization" do
      it "returns the user" do
        user.authorizations.create(auth_params)
        expect(User.find_for_oauth(auth)).to eq(user)
      end
    end

    context "without authorization" do
      let(:auth_params) { {provider: 'facebook', uid: '123456',
        info: {email: user.email} } }

      context 'registered user' do
        it "doesn't create new user" do
          expect { User.find_for_oauth(auth) }.to_not change(User,:count)
        end

        it "creates authorizations for user" do
          expect {
            User.find_for_oauth(auth)
          }.to change(user.authorizations, :count).by(1)
        end

        it "creates authorization with provider & uid" do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq(auth.provider)
          expect(authorization.uid).to eq(auth.uid)
        end

        it 'returns the user' do
          expect(User.find_for_oauth(auth)).to eq(user)
        end
      end
    end

    context "user doesn't exist" do
      let(:auth_params) { {provider: 'facebook', uid: '123456',
        info: {email: '123@user.com'} } }

      it "creates new user" do
        expect{
          User.find_for_oauth(auth)
        }.to change(User,:count).by(1)
      end

      it "returns new user" do
        expect(User.find_for_oauth(auth)).to be_a(User)
      end

      it "fills user email" do
        user = User.find_for_oauth(auth)
        expect(user.email).to eq('123@user.com')
      end

      it "fills user name from email" do
        user = User.find_for_oauth(auth)
        expect(user.name).to eq('123')
      end

      it "creates authorization with provider & uid" do
        authorization = User.find_for_oauth(auth).authorizations.first
        expect(authorization.provider).to eq(auth.provider)
        expect(authorization.uid).to eq(auth.uid)
      end
    end
  end
end
