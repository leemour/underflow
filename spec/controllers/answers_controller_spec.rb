require 'spec_helper'

describe AnswersController do
  describe "POST #create" do
    context "with valid attributes" do
      before { login_user }

      it "saves new Answer to DB" do
        question = create(:question)
        expect{
          post :create, answer: attributes_for(:answer, question_id: question)
        }.to change(Answer, :count).by(1)
      end

      it 'redirects to answered Question' do
        question = create(:question)
        post :create, answer: attributes_for(:answer, question_id: question)

        expect(request).to redirect_to(question_path(question))
      end
    end

    context "with invalid attributes" do

    end
  end
end