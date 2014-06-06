require 'spec_helper'

describe VotesController do
  describe "POST #up" do
    let(:question) { create(:question) }

    context 'when logged in' do
      before { login_user }

      it "finds Question to vote for" do
        post :up, question_id: question
        expect(assigns(:voteable)).to eq(question)
      end

      context "if already voted" do
        it "deletes Question Vote if upvoted" do
          question.vote_up(@user)
          post :up, question_id: question
          expect(@user.get_vote_for(question)).to be_nil
        end

        it "changes Question Vote value by +2 if downvoted" do
          question.vote_down(@user)
          expect {
            post :up, question_id: question
          }.to change(question, :vote_sum).by(2)
        end
      end

      context "if not voted" do
        it "adds Vote with +1 value" do
          expect {
            post :up, question_id: question
          }.to change(question, :vote_sum).by(1)
        end
      end
    end

    context 'when not logged in' do
      before { post :up, question_id: question }

      it "redirects to login page" do
        expect(request).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST #down" do
    let(:question) { create(:question) }

    context 'when logged in' do
      before { login_user }

      it "finds Question to vote for" do
        post :down, question_id: question
        expect(assigns(:voteable)).to eq(question)
      end

      context "if already voted" do
        it "deletes Question Vote if downvoted" do
          question.vote_down(@user)
          post :down, question_id: question
          expect(@user.get_vote_for(question)).to be_nil
        end

        it "changes Question Vote value by -2 if upvoted" do
          question.vote_up(@user)
          expect {
            post :down, question_id: question
          }.to change(question, :vote_sum).by(-2)
        end
      end

      context "if not voted" do
        it "adds Vote with -1 value" do
          expect {
            post :down, question_id: question
          }.to change(question, :vote_sum).by(-1)
        end
      end
    end

    context 'when not logged in' do
      before { post :down, question_id: question }

      it "redirects to login page" do
        expect(request).to redirect_to(new_user_session_path)
      end
    end
  end
end