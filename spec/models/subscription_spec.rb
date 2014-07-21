require 'spec_helper'

describe Subscription do
  it { should belong_to(:user) }
  it { should belong_to(:subscribable) }
end
