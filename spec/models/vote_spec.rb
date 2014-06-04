require 'spec_helper'

describe Vote do
  it { should belong_to(:user) }
  it { should belong_to(:voteable) }
  it { should ensure_inclusion_of(:value).in_array([-1, 1]) }
end