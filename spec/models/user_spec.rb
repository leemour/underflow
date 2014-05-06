require 'spec_helper'

describe User do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :comments }

  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
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
  it { should allow_value('http://underflow.com').for(:website) }
  it do
    should_not allow_value(
      'ttp://mail.ru',
      'underflow',
      '123.ru',
      '.ru'
    ).for(:website)
  end

  # it { should allow_value('2013-01-01').for(:birthday) }
  # it do
  #   should_not allow_value(
  #     '01.01-2013',
  #     '01/01-2013',
  #     '01-01-99',
  #     '32-02-2013',
  #     '01-13-2010'
  #   ).for(:birthday)
  # end
end
