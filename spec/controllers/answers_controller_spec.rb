require 'spec_helper'

describe AnswersController do

  describe "GET #by_user" do
    let(:user) { create(:user) }
    let(:answers) { create_list(:answer, 3, user: user) }
    before { get :by_user, user_id: user }

    it "assigns user Answers to @answers" do
      expect(assigns(:answers)).to match_array(answers)
    end

    it "renders :index view" do
      expect(response).to render_template 'by_user'
    end
  end

  describe "POST #create" do
    let(:question) { create(:question) }

    context 'when logged in' do
      before { login_user }

      context "with valid attributes" do
        context 'with AJAX' do
           it "saves new Answer to DB" do
            expect {
              post :create, answer: attributes_for(:answer),
                question_id: question, format: :js
            }.to change(question.answers, :count).by(1)
          end

           it "renders :create view" do
            post :create, answer: attributes_for(:answer),
              question_id: question, format: :js
            expect(response).to render_template 'create'
          end
        end

        context 'without AJAX' do
          it "saves new Answer to DB" do
            expect {
              post :create, answer: attributes_for(:answer), question_id: question
            }.to change(question.answers, :count).by(1)
          end

          it 'redirects to answered Question' do
            post :create, answer: attributes_for(:answer), question_id: question
            expect(request).to redirect_to(question_path(question))
          end
        end
      end

      context "with invalid attributes" do
        context 'with AJAX' do
          it "doesn't save new Answer to DB" do
            expect {
              post :create, answer: {body: ''}, question_id: question,
                format: :js
            }.to change(question.answers, :count).by(0)
          end

          it 'renders :create view' do
            post :create, answer: {body: ''}, question_id: question, format: :js
            expect(request).to render_template 'create'
          end
        end

        context 'without AJAX' do
          it "doesn't save new Answer to DB" do
            expect{
              post :create, answer: {body: ''}, question_id: question
            }.to change(question.answers, :count).by(0)
          end

          it 'redirects to answered Question with error' do
            post :create, answer: {body: ''}, question_id: question
            expect(request).to render_template 'new'
          end
        end
      end
    end

    context 'when not logged in' do
      it "redirects to log in page" do
        post :create, answer: attributes_for(:answer), question_id: question
        expect(request).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #edit' do
    subject { create(:answer) }
    before do
      login_user
      get :edit, id: subject, question_id: create(:question)
    end

    it "finds Answer to edit" do
      expect(assigns(:answer)).to eq(subject)
    end
  end

  describe 'PATCH #update' do
    before { login_user }
    let(:question) { create(:question) }
    subject { create(:answer, user: @user, question: question,
      body: 'Not updated body. Not updated body. Not updated body.') }

    context 'with valid attributes' do
      context "with AJAX" do
        before do
          patch :update, id: subject, question_id: question, format: :js,
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

        it "renders :update view" do
          expect(response).to render_template 'update'
        end
      end

      context "without AJAX" do
        before do
          patch :update, id: subject, question_id: question,
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
    end

    context "with invalid attributes" do
      before do
        patch :update, id: subject, question_id: question,
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

    context "when not user's Answer" do
      it "doesn't change @answer attributes" do
        alien_answer = create(:answer, user: create(:user),
          body: 'Not updated body. Not updated body.')

        patch :update, id: alien_answer, question_id: question,
          answer: attributes_for(:answer, body: 'Updated body! Updated body! Updated body!')
        alien_answer.reload

        expect(alien_answer.body).to eq('Not updated body. Not updated body.')
      end

      it "responds with 403 status" do
        alien_answer = create(:answer, user: create(:user),
          body: 'Not updated body. Not updated body.')

        patch :update, id: alien_answer, question_id: question,
          answer: attributes_for(:answer, body: 'Updated body! Updated body! Updated body!')
        alien_answer.reload

        expect(response.status).to eq(403)
      end
    end
  end

  describe "DELETE destroy" do
    before { login_user }
    let(:question) { create(:question) }
    let!(:answer) { create(:answer, user: @user, question: question) }

    context "when user's Answer" do
      context "with AJAX" do
        it "deletes the requested Answer" do
          expect {
            delete :destroy, id: answer, question_id: question, format: :js
          }.to change(@user.answers, :count).by(-1)
        end

        it "renders :destroy view" do
          delete :destroy, id: answer, question_id: question, format: :js
          expect(response).to render_template 'destroy'
        end
      end

      context "without AJAX" do
        it "finds Answer to delete" do
          delete :destroy, id: answer, question_id: question
          expect(assigns(:answer)).to eq(answer)
        end

        it "deletes the requested Answer" do
          expect {
            delete :destroy, id: answer, question_id: question
          }.to change(@user.answers, :count).by(-1)
        end

        it "redirects to Answer's Question" do
          delete :destroy, id: answer, question_id: question
          expect(response).to redirect_to question_path(answer.question)
        end
      end
    end

    context "when not user's Answer" do
      let!(:alien_answer) { create(:answer, user: create(:user),
        question: question) }

      it "doesn't delete Answer from DB" do
        expect {
          delete :destroy, id: alien_answer, question_id: question
        }.to_not change(Answer, :count)
      end

      it "responds with 403 status" do
        delete :destroy, id: alien_answer, question_id: question
        expect(response.status).to eq(403)
      end
    end
  end
end