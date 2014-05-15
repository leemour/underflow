require 'spec_helper'

describe Profile do
  it { should belong_to :user }

  it { should allow_value('Henry Ford').for(:real_name) }
  it { should allow_value('http://underflow.com').for(:website) }

  it do
    should_not allow_value(
      'ttp://mail.ru',
      '&block',
      '****',
      '&&&'
    ).for(:real_name)
  end
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