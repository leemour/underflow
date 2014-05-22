require 'spec_helper'

describe Tag do
  it { should have_and_belong_to_many :questions }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }
  it { should ensure_length_of(:name).is_at_least(1).is_at_most(30) }
  it { should ensure_length_of(:excerpt).is_at_least(15).is_at_most(500) }
  it { should ensure_length_of(:description).is_at_least(30).is_at_most(6000) }

  describe '#name_list' do
    it "returns array of tag names" do
      create(:tag, name: 'a')
      create(:tag, name: 'b')
      expect(Tag.name_list).to eq(['a', 'b'])
    end
  end
end
