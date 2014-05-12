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
          }.to change(question.answers, :count).by(1)
        end

        it 'redirects to answered Question' do
          post :create, answer: attributes_for(:answer, question_id: question)
          expect(request).to redirect_to(question_path(question))
        end
      end

      context "with invalid attributes" do
        it "doesn't save new Answer to DB" do
          expect{
            post :create, answer: {body: '', question_id: question}
          }.to change(question.answers, :count).by(0)
        end

        it 'redirects to answered Question with error' do
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

  describe 'GET #edit' do
    subject { create(:answer) }
    before do
      login_user
      get :edit, id: subject
    end

    it "finds Answer to edit" do
      expect(assigns(:answer)).to eq(subject)
    end
  end

  describe 'PATCH #update' do
    subject { create(:answer, question: create(:question),
      body: 'Not updated body. Not updated body. Not updated body.') }
    before { login_user }

    context 'with valid attributes' do
      before do
        patch :update, id: subject,
          answer: attributes_for(:answer,
            body: 'Updated body! Updated body! Updated body! Updated body!')
      end

      it "finds Answer to edit" do
        expect(assigns(:answer)).to eq(subject)
      end

      it 'updates @answer body' do
        subject.reload
        expect(subject.body).to eq('Updated body! Updated body! Updated body! Updated body!')
      end

      it "redirects to the Answer Question" do
        expect(response).to redirect_to subject.question
      end
    end

    context "with invalid attributes" do
      before do
        patch :update, id: subject,
          answer: attributes_for(:answer, body: 'Too short')
      end

      it "finds Answer for update" do
        expect(assigns(:answer)).to eq(subject)
      end

      it "doesn't change @answer attributes" do
        subject.reload
        expect(subject.body).to eq('Not updated body. Not updated body. Not updated body.')
      end

      it "re-renders :edit view" do
        expect(response).to render_template 'edit'
      end
    end


  describe "DELETE destroy" do
    let!(:answer) { create(:answer, question: create(:question)) }
    before { login_user }

    it "finds Question to delete" do
      delete :destroy, id: answer
      expect(assigns(:answer)).to eq(answer)
    end

    it "deletes the requested Question" do
      expect{
        delete :destroy, id: answer
      }.to change(Answer, :count).by(-1)
    end

    it "redirects to question index" do
      delete :destroy, id: answer
      expect(response).to redirect_to question_path(answer.question)
    end
  end
  end
end