require 'spec_helper'

describe AnswersController do
  describe "POST #create" do
    let(:question) { create(:question) }

    context 'when logged in' do
      before { login_user }

      context "with valid attributes" do
        it "saves new Answer to DB" do
          expect{
            post :create, answer: attributes_for(:answer, question_id: question)
          }.to change(Answer, :count).by(1)
        end

        it 'redirects to answered Question' do
          post :create, answer: attributes_for(:answer, question_id: question)
          expect(request).to redirect_to(question_path(question))
        end
      end

      context "with invalid attributes" do
        it 'redirects to Question with error' do
          post :create, answer: {body: '', question_id: question}
          expect(request).to redirect_to(question_path(question))
        end
      end
    end

    context 'when not logged in' do
      it "redirects to log in page" do
        post :create, answer: attributes_for(:answer, question_id: question)
        expect(request).to redirect_to(new_user_session_path)
      end
    end
  end
end