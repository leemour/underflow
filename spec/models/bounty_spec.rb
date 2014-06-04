require 'spec_helper'

describe Bounty do
  it { should belong_to :question }
  it { should belong_to :winner }
  it { should have_one :owner }
  it { should validate_numericality_of(:value).is_greater_than_or_equal_to(50) }
end
