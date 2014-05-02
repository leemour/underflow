require 'spec_helper'

describe Tag do
  it { should have_and_belong_to_many :questions }

  it { should validate_presence_of :name }
  it { should validate_presence_of :description }
  it { should ensure_length_of(:name).is_at_least(2).is_at_most(30) }
  it { should ensure_length_of(:excerpt).is_at_least(15).is_at_most(500) }
  it { should ensure_length_of(:description).is_at_least(100).is_at_most(6000) }
end
