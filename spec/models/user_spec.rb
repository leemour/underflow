require 'spec_helper'

describe User do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :comments }
  it { should have_one :profile }

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
end
