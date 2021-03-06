require 'spec_helper'

describe AnswersController do

  describe "PATCH #accept" do
    before { login_user }

    context 'when not Question author' do
      let(:question) { create(:question) }
      let(:answer) { create(:answer, question: question) }
      before { patch :accept, question_id: question, id: answer }

      it "doesn't accept answer" do
        answer.reload
        expect(answer.accepted).to be_false
      end

      it "responds with 403 status" do
        expect(response.status).to eq(403)
      end
    end

    context 'when Question author' do
      let(:question) { create(:question, user: @user) }
      let(:answer) { create(:answer, question: question) }
      let!(:bounty) { create(:bounty, question: question) }
      before { patch :accept, question_id: question, id: answer }

      it "finds Answer to accept" do
        expect(assigns(:answer)).to eq(answer)
      end

      context 'when no Answers accepted' do
        it "toggles Answer accepted value" do
          expect(assigns(:answer).accepted).to be_true
        end
      end

      context 'when Answer already accepted' do
        before { patch :accept, question_id: question, id: answer }

        it "toggles Answer accepted value" do
          expect(assigns(:answer).accepted).to be_false
        end
      end

      it "awards Bounty if exists" do
        bounty.reload
        expect(bounty.winner).to eq(answer.user)
      end

      it "redirects to Answer Question" do
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'when Question has accepted Answer' do
      let(:question) { create(:question, user: @user) }
      let!(:accepted_answer) { create(:answer, question: question,
        accepted: true) }
      let(:answer) { create(:answer, question: question) }
      before { patch :accept, question_id: question, id: answer }

      it "finds Answer Question" do
        expect(assigns(:question)).to eq(question)
      end

      it "finds already accepted answer" do
        expect(assigns(:question).accepted_answer).to eq(accepted_answer)
      end

      it "doesn't toggle Answer accepted value" do
        expect(assigns(:answer).accepted).to be_false
      end

      it "responds with 403 status" do
        expect(response.status).to eq(403)
      end
    end

    context 'when Answer already accepted' do
      let(:question) { create(:question, user: @user) }
      let(:answer) { create(:answer, question: question, accepted: true) }
      before { patch :accept, question_id: question, id: answer }

      it "toggles Answer accepted value to false" do
        expect(assigns(:answer).accepted).to be_false
      end

      it "redirects to Answer Question" do
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe "GET #by_user" do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let(:answers) { create_list(:answer, 3, user: user, question: question) }
    before { get :by_user, user_id: user }

    it "assigns user Answers to @answers" do
      expect(assigns(:answers)).to match_array(answers)
    end

    it "renders :by_user view" do
      expect(response).to render_template 'by_user'
    end
  end

  describe "GET #voted" do
    let(:user) { create(:user) }
    let(:answer1) { create(:answer) }
    let(:answer2) { create(:answer) }
    let(:answer3) { create(:answer) }

    before do
      create(:vote, voteable: answer1, user: user)
      create(:vote, voteable: answer2, user: user)
      get :voted, user_id: user
    end

    it "assigns user Answers to @answers" do
      expect(assigns(:answers)).to eq Answer.voted_by(user.id)
    end

    it "renders :voted view" do
      expect(response).to render_template 'voted'
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
    let(:question) { create(:question) }

    context 'when Answer owner' do
      subject { create(:answer, question: question, user: @user) }
      before do
        login_user
        get :edit, id: subject, question_id: question
      end

      it "finds Answer to edit" do
        expect(assigns(:answer)).to eq(subject)
      end

      it { should render_template 'edit' }
    end

    context 'when not Answer owner' do
      subject { create(:answer, question: question) }
      before do
        login_user
        get :edit, id: subject, question_id: question
      end

      it { should render_template 'static/error' }
    end

    context 'when not logged in' do
      subject { create(:answer, question: question) }
      before { get :edit, id: subject, question_id: question }

      it "redirects to log in page" do
        expect(request).to redirect_to(new_user_session_path)
      end
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
        alien_answer = create(:answer, user: create(:user), question: question,
          body: 'Not updated body. Not updated body.')

        patch :update, id: alien_answer, question_id: question,
          answer: attributes_for(:answer, body: 'Updated body! Updated body! Updated body!')
        alien_answer.reload

        expect(alien_answer.body).to eq('Not updated body. Not updated body.')
      end

      it "responds with 403 status" do
        alien_answer = create(:answer, user: create(:user), question: question,
          body: 'Not updated body. Not updated body.')

        patch :update, id: alien_answer, question_id: question,
          answer: attributes_for(:answer, body: 'Updated body! Updated body! Updated body!')
        alien_answer.reload

        expect(response.status).to eq(403)
      end
    end
  end

  describe "DELETE #destroy" do
    context 'when not logged in' do
      let(:question) { create(:question) }
      let!(:answer) { create(:answer) }

      it "doesn't delete Answer from DB" do
        expect {
          delete :destroy, id: answer, question_id: question
        }.to_not change(Answer, :count)
      end

      it "redirects to login path" do
        delete :destroy, id: answer, question_id: question
        expect(response).to redirect_to new_user_session_path
      end
    end


    context "when user's Answer" do
      before { login_user }
      let(:question) { create(:question) }
      let!(:answer) { create(:answer, user: @user, question: question) }
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
      before { login_user }
      let(:question) { create(:question) }
      let!(:alien_answer) { create(:answer, question: question) }

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