require 'spec_helper'

describe ReputationObserver do
  subject { ReputationObserver.instance }

  # it 'observers Question' do
  #   expect(Question.observers).to include ReputationObserver
  # end

  context 'when Answer created' do
    it "calls Reputation.created_answer" do
      answer = build(:answer)
      expect(Reputation).to receive(:created_answer).with(answer)
      answer.save!
    end
  end

  context 'when Vote created' do
    context 'when upvote' do
      it "calls Reputation.voted" do
        vote = build(:vote, voteable: create(:question), value: 1)
        expect(Reputation).to receive(:voted).with(vote, :vote_up)
        vote.save!
      end
    end

    context 'when downvote' do
      it "calls Reputation.voted" do
        vote = build(:vote, voteable: create(:question), value: -1)
        expect(Reputation).to receive(:voted).with(vote, :vote_down)
        vote.save!
      end
    end
  end
end