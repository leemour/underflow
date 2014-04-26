require 'spec_helper'

describe Question do
  it { should belong_to :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should ensure_length_of(:title).is_at_least(15) }
  it { should ensure_length_of(:title).is_at_most(60) }
  it { should ensure_length_of(:body).is_at_least(100) }
  it { should ensure_length_of(:body).is_at_most(6000) }

end
