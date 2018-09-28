require 'spec_helper'

describe Bounty do
  it { should belong_to :question }
  it { should belong_to :winner }
  it { should have_one :owner }
  it { should validate_numericality_of(:value).is_greater_than_or_equal_to(50) }

  # describe '#award_to' do
  #   let(:question) { create(:question) }
  #   let(:answer)   { create(:answer, question: question) }
  #   let!(:bounty)   { create(:bounty, question: question) }

  #   it "adds Answer to Bounty as winner" do
  #     Bounty.award_to answer
  #     expect(bounty.winner).to eq(answer.user)
  #   end

  #   it "adds Bounty value to user reputation" do
  #     expect {
  #       Bounty.award_to answer
  #     }.to change(answer.user, :reputation).by(bounty.value)
  #   end
  # end
end

# question = FactoryBot.create(:question)
# bounty = FactoryBot.create(:bounty, question: question)
# answer = FactoryBot.create(:answer, question: question)
