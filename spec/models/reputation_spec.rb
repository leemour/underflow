require 'spec_helper'

describe Reputation do
  let!(:user) { create(:user) }

  describe '.created_answer' do

    context 'other user Question' do
      let(:question) { create(:question) }
      let(:answer) { build(:answer, user: user, question: question) }

      context 'first Answer' do
        it 'increases User reputation by 2' do
          allow(question).to receive(:answers).and_return([answer])
          expect {
            Reputation.created_answer(answer)
          }.to change(user, :reputation).by(2)
        end
      end

      context 'consequent Answer' do
        it 'increases User reputation by 1' do
          create(:answer, question: question)
          expect {
            Reputation.created_answer(answer)
          }.to change(user, :reputation).by(1)
        end
      end
    end

    context 'own Question' do
      let(:question) { create(:question, user: user) }
      let(:answer) { build(:answer, user: user, question: question) }

      context 'first Answer' do
        it 'increases User reputation by 3' do
          allow(question).to receive(:answers).and_return([answer])
          expect {
            Reputation.created_answer(answer)
          }.to change(user, :reputation).by(3)
        end
      end

      context 'consequent Answer' do
        it 'increases User reputation by 2' do
          create(:answer, question: question)
          expect {
            Reputation.created_answer(answer)
          }.to change(user, :reputation).by(2)
        end
      end
    end
  end

  describe '.voted' do
    context 'up' do
      context 'Question' do
        let(:question) { create(:question, user: user) }

        it 'increases User reputation by 2' do
          vote = build(:vote, voteable: question, value: 1)
          expect {
            Reputation.voted(vote)
          }.to change(user, :reputation).by(2)
        end
      end

      context 'Answer' do
        let(:answer) { create(:answer, user: user) }

        it 'increases User reputation by 1' do
          vote = build(:vote, voteable: answer, value: 1)
          expect {
            Reputation.voted(vote)
          }.to change(user, :reputation).by(1)
        end
      end
    end

    context 'down' do
      context 'Question' do
        let(:question) { create(:question, user: user) }

        it 'increases User reputation by 2' do
          vote = build(:vote, voteable: question, value: -1)
          expect {
            Reputation.voted(vote)
          }.to change(user, :reputation).by(-2)
        end
      end

      context 'Answer' do
        let!(:answer) { create(:answer, user: user) }

        it 'increases User reputation by 1' do
          vote = build(:vote, voteable: answer, value: -1)
          expect {
            Reputation.voted(vote)
          }.to change(user, :reputation).by(-1)
        end
      end
    end
  end

  describe '.accepted_answer' do
    let(:question) { create(:question) }

    context 'when not accepted before' do
      let(:answer) { build(:answer, user: user, question: question) }

      it 'increases User reputation by 3' do
        expect {
          Reputation.accepted_answer(answer, true)
        }.to change(user, :reputation).by(3)
      end
    end

    context 'when accepted before' do
      let(:answer) do
        build(:answer, user: user, question: question, accepted: true)
      end

      it 'decreases User reputation by -3' do
        expect {
          Reputation.accepted_answer(answer, false)
        }.to change(user, :reputation).by(-3)
      end
    end
  end
end
