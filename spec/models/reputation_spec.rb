require 'spec_helper'

describe Reputation do
  let!(:user) { create(:user) }

  describe 'self#created_answer' do

    context 'other user Question' do
      let(:question) { create(:question) }

      context 'first answer' do
        it 'increases User reputation by 2' do
          expect {
            create(:answer, user: user, question: question)
          }.to change(user, :reputation).by(2)
        end
      end

      context 'first answer direct call' do
        it 'increases User reputation by 2' do
          answer = build(:answer, user: user, question: question)
          question.stub(:answers).and_return([answer])
          expect {
            Reputation.created_answer(answer)
          }.to change(user, :reputation).by(2)
        end
      end

      context 'consequent answer' do
        it 'increases User reputation by 1' do
          create(:answer, question: question)
          expect {
            create(:answer, user: user, question: question)
          }.to change(user, :reputation).by(1)
        end
      end
    end

    context 'own Question' do
      let(:question) { create(:question, user: user) }

      context 'first answer' do
        it 'increases User reputation by 3' do
          expect {
            create(:answer, user: user, question: question)
          }.to change(user, :reputation).by(3)
        end
      end

      context 'consequent answer' do
        it 'increases User reputation by 2' do
          create(:answer, question: question)
          expect {
            create(:answer, user: user, question: question)
          }.to change(user, :reputation).by(2)
        end
      end
    end
  end

  describe 'self#voted' do
    context 'up' do
      context 'Question' do
        let!(:question) { create(:question, user: user) }

        it 'increases User reputation by 2' do
          expect {
            create(:vote, voteable: question, value: 1)
          }.to change(user, :reputation).by(2)
        end
      end

      context 'Answer' do
        let!(:answer) { create(:answer, user: user) }

        it 'increases User reputation by 1' do
          expect {
            create(:vote, voteable: answer, value: 1)
          }.to change(user, :reputation).by(1)
        end
      end
    end

    context 'down' do
      context 'Question' do
        let!(:question) { create(:question, user: user) }

        it 'increases User reputation by 2' do
          expect {
            create(:vote, voteable: question, value: -1)
          }.to change(user, :reputation).by(-2)
        end
      end

      context 'Answer' do
        let!(:answer) { create(:answer, user: user) }

        it 'increases User reputation by 1' do
          expect {
            create(:vote, voteable: answer, value: -1)
          }.to change(user, :reputation).by(-1)
        end
      end
    end
  end

  describe 'self#accepted_answer' do
    let(:question) { create(:question) }

    context 'when not accepted before' do
      let!(:answer) { create(:answer, user: user, question: question) }

      it 'increases User reputation by 3' do
        expect {
          answer.toggle_accepted_from question
        }.to change(user, :reputation).by(3)
      end
    end

    context 'when accepted before' do
      let!(:answer) do
        create(:answer, user: user, question: question, accepted: true)
      end

      it 'decreases User reputation by -3' do
        expect {
          answer.toggle_accepted_from question
        }.to change(user, :reputation).by(-3)
      end
    end
  end
end
