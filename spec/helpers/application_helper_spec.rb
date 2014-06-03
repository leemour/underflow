require 'spec_helper'

describe ApplicationHelper do
  describe '#class_with_id' do
    it "returns object class with id for CSS selector" do
      question = create(:question, id: 1)
      expect(class_with_id(question)).to eq('#question-1')
    end
  end
end