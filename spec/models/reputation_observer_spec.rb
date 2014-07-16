require 'spec_helper'

describe ReputationObserver do
  subject { ReputationObserver.instance }

  context 'when Answer created' do
    it "calls Reputation.created_answer" do
      answer = build(:answer)
      expect(Reputation).to receive(:created_answer).with(answer)
      answer.save!
    end
  end

  context 'when updating Answer' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, accepted: true) }

    it 'calls Reputation.accepted when answer accepted' do
      expect(Reputation).to receive(:accepted_answer).with(answer, false)
      answer.toggle_accepted_from question
    end

    it 'calls Reputation.accepted when answer not accepted' do
      answer.update(accepted: false)
      expect(Reputation).to receive(:accepted_answer).with(answer, true)
      answer.toggle_accepted_from question
    end
  end

  context 'when Vote created' do
    [:question, :answer].each do |object|
      context "on #{object}" do
        context 'when upvote' do
          it "calls Reputation.voted" do
            vote = build(:vote, voteable: create(object), value: 1)
            expect(Reputation).to receive(:voted).with(vote)
            vote.save!
          end
        end

        context 'when downvote' do
          it "calls Reputation.voted" do
            vote = build(:vote, voteable: create(object), value: -1)
            expect(Reputation).to receive(:voted).with(vote)
            vote.save!
          end
        end
      end
    end
  end
end