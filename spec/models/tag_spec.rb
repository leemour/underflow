require 'spec_helper'

describe Tag do
  it { should have_and_belong_to_many :questions }

  it { should validate_presence_of :name }
  it { should validate_presence_of :body }
  it { should ensure_length_of(:name).is_at_least(2).is_at_most(30) }
  it { should ensure_length_of(:excerpt).is_at_least(15).is_at_most(500) }
  it { should ensure_length_of(:body).is_at_least(100).is_at_most(6000) }

  it "is added to question when question is created" do
    question = create(:question)
    tag = create(:tag)
    question.tags << tag
    question.tags.create(name: 'hi', body: 'Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet ')
    question.tags.unscoped.should == [tag]
  end
end
