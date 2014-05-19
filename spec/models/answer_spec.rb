require 'spec_helper'

describe Answer do
  it { should belong_to :user }
  it { should have_db_index :user_id }
  it { should belong_to :question }
  it { should have_db_index :question_id }
  it { should have_many :comments }
  it { should have_many :attachments }

  it { should validate_presence_of(:body) }
  it { should ensure_length_of(:body).is_at_least(30).is_at_most(6000) }
end
