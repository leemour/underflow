require 'spec_helper'

describe Question do
  it { should belong_to :user }
  it { should have_db_index :user_id }
  it { should have_many :answers }
  it { should have_many :comments }
  it { should have_many :attachments }
  it { should have_and_belong_to_many :tags }

  it { should accept_nested_attributes_for :attachments }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should ensure_length_of(:title).is_at_least(15).is_at_most(60) }
  it { should ensure_length_of(:body).is_at_least(60).is_at_most(6000) }

  context 'when created' do
    subject { build(:question) }

    it { should be_active }
    it { should_not be_deleted }
  end

  describe '#from?(user)' do
    let(:user) { create(:user) }

    it 'returns true when user is the author' do
      question = create(:question, user: user)
      expect(question).to be_from(user)
    end

    it 'returns false when user is not the author' do
      question = create(:question)
      expect(question).to_not be_from(user)
    end
  end

  describe '#tag_list' do
    subject { create(:question) }
    let!(:tags) { create_list(:tag, 3, questions: [subject]) }

    it "returns array of Question Tag names" do
      tag_names = tags.map(&:name)
      expect(subject.tag_list).to match_array(tag_names)
    end
  end

  describe '#tag_list=' do
    subject { create(:question) }
    let!(:tag) { create(:tag, name: 'tag1', questions: [subject]) }

    it "creates tag that doesn't exist" do
      expect {
        subject.update(tag_list: 'tag1,tag2')
      }.to change(Tag, :count).by(1)
    end

    it "doesn't delete tags that exist" do
      expect {
        subject.update(tag_list: '')
      }.to_not change(Tag, :count)
    end

    it "doesnt' delete tags already associated with question" do
      expect {
        subject.update(tag_list: 'tag1')
      }.to change(subject.tags, :count).by(0)
    end

    it "keeps tags name already associated with question" do
      subject.update(tag_list: 'tag1')
      expect(subject.tags.first).to eq(tag)
    end

    it "adds new tags to question" do
      expect {
        subject.update(tag_list: 'tag1,tag2')
      }.to change(subject.tags, :count).by(1)
    end

    it "removes already associated tags from question" do
      expect {
        subject.update(tag_list: '')
      }.to change(subject.tags, :count).by(-1)
    end
  end
end
