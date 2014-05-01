require 'spec_helper'

describe Question do
  it { should belong_to :user }
  it { should have_db_index :user_id }
  it { should have_many :answers }
  it { should have_many :comments }
  it { should have_and_belong_to_many :tags }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should ensure_length_of(:title).is_at_least(15).is_at_most(60) }
  it { should ensure_length_of(:body).is_at_least(100).is_at_most(6000) }

  context 'when created' do
    subject { create(:question) }

    it { should be_active }
  end
end
