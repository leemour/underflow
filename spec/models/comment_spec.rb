require 'spec_helper'

describe Comment do
  it { should belong_to(:user) }
  it { should belong_to(:commentable) }

  it { should validate_presence_of(:body) }
  it { should ensure_length_of(:body).is_at_least(15).is_at_most(500) }
end
