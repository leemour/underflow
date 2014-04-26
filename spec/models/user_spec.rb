require 'spec_helper'

describe User do
  it { should have_many :questions }

  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should ensure_length_of(:name).is_at_least(3) }
  it { should ensure_length_of(:name).is_at_most(30) }

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
