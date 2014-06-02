require 'spec_helper'

describe VotesController do
  describe "GET #up" do
    let(:question) { create(:question) }

    context 'when logged in' do
      before { login_user }

      it "finds Question to vote for" do
        get :up, question_id: question
        expect(assigns(:voteable)).to eq(question)
      end

      context "if already voted" do
        it "deletes Question Vote if upvoted" do
          question.vote_up(@user)
          get :up, question_id: question
          expect(@user.vote(question)).to be_nil
        end

        it "changes Question Vote value by +2 if downvoted" do
          question.vote_down(@user)
          expect {
            get :up, question_id: question
          }.to change(question, :vote_sum).by(2)
        end
      end

      context "if not voted" do
        it "adds Vote with +1 value" do
          expect {
            get :up, question_id: question
          }.to change(question, :vote_sum).by(1)
        end
      end
    end

    context 'when not logged in' do
      before { get :up, question_id: question }

      it "redirects to login page" do
        expect(request).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET #down" do
    let(:question) { create(:question) }

    context 'when logged in' do
      before { login_user }

      it "finds Question to vote for" do
        get :down, question_id: question
        expect(assigns(:voteable)).to eq(question)
      end

      context "if already voted" do
        it "deletes Question Vote if downvoted" do
          question.vote_down(@user)
          get :down, question_id: question
          expect(@user.vote(question)).to be_nil
        end

        it "changes Question Vote value by -2 if upvoted" do
          question.vote_up(@user)
          expect {
            get :down, question_id: question
          }.to change(question, :vote_sum).by(-2)
        end
      end

      context "if not voted" do
        it "adds Vote with -1 value" do
          expect {
            get :down, question_id: question
          }.to change(question, :vote_sum).by(-1)
        end
      end
    end

    context 'when not logged in' do
      before { get :down, question_id: question }

      it "redirects to login page" do
        expect(request).to redirect_to(new_user_session_path)
      end
    end
  end
end