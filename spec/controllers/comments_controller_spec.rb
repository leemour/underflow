require 'spec_helper'

describe CommentsController do

  describe "POST #create" do
    let(:question) { create(:question) }

    context 'when logged in' do
      before { login_user }

      context "with valid attributes" do
        context 'with AJAX' do
           it "saves new Comment to DB" do
            expect {
              post :create, comment: attributes_for(:comment),
                question_id: question, format: :js
            }.to change(question.comments, :count).by(1)
          end

           it "renders :create view" do
            post :create, comment: attributes_for(:comment),
              question_id: question, format: :js
            expect(response).to render_template 'create'
          end
        end

        context 'without AJAX' do
          it "saves new Comment to DB" do
            expect {
              post :create, comment: attributes_for(:comment), question_id: question
            }.to change(question.comments, :count).by(1)
          end

          it 'redirects to commented Question' do
            post :create, comment: attributes_for(:comment), question_id: question
            expect(request).to redirect_to(question_path(question))
          end
        end
      end

      context "with invalid attributes" do
        context 'with AJAX' do
          it "doesn't save new Comment to DB" do
            expect {
              post :create, comment: {body: ''}, question_id: question,
                format: :js
            }.to change(question.comments, :count).by(0)
          end

          it 'renders :create view' do
            post :create, comment: {body: ''}, question_id: question, format: :js
            expect(request).to render_template 'create'
          end
        end

        context 'without AJAX' do
          it "doesn't save new Comment to DB" do
            expect{
              post :create, comment: {body: ''}, question_id: question
            }.to change(question.comments, :count).by(0)
          end

          it 'redirects to answered Question with error' do
            post :create, comment: {body: ''}, question_id: question
            expect(request).to render_template 'new'
          end
        end
      end
    end

    context 'when not logged in' do
      it "redirects to log in page" do
        post :create, comment: attributes_for(:comment), question_id: question
        expect(request).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #edit' do
    let(:question) { create(:question) }

    context 'when Comment owner' do
      subject { create(:comment, commentable: question, user: @user) }
      before do
        login_user
        get :edit, id: subject, question_id: question
      end

      it "finds Comment to edit" do
        expect(assigns(:comment)).to eq(subject)
      end

      it { should render_template 'edit' }
    end

    context 'when not Comment owner' do
      subject { create(:comment, commentable: question) }
      before do
        login_user
        get :edit, id: subject, question_id: question
      end

      it { should render_template 'static/error' }
    end

    context 'when not logged in' do
      subject { create(:comment, commentable: question) }
      before { get :edit, id: subject, question_id: question }

      it "redirects to log in page" do
        expect(request).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    before { login_user }
    let(:question) { create(:question) }
    subject { create(:comment, user: @user, commentable: question,
      body: 'Not updated body. Not updated body. Not updated body.') }

    context 'with valid attributes' do
      context "with AJAX" do
        before do
          patch :update, id: subject, question_id: question, format: :js,
            comment: attributes_for(:comment,
              body: 'Updated body! Updated body! Updated body! Updated body!')
        end

        it "finds Comment to edit" do
          expect(assigns(:comment)).to eq(subject)
        end

        it 'updates @comment body' do
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
            comment: attributes_for(:comment,
              body: 'Updated body! Updated body! Updated body! Updated body!')
        end

        it "finds Comment to edit" do
          expect(assigns(:comment)).to eq(subject)
        end

        it 'updates @comment body' do
          subject.reload
          expect(subject.body).to eq('Updated body! Updated body! Updated body! Updated body!')
        end

        it "redirects to the Comment Question" do
          expect(response).to redirect_to subject.commentable
        end
      end
    end

    context "with invalid attributes" do
      before do
        patch :update, id: subject, question_id: question,
          comment: attributes_for(:comment, body: 'Too short')
      end

      it "finds Comment for update" do
        expect(assigns(:comment)).to eq(subject)
      end

      it "doesn't change @comment attributes" do
        subject.reload
        expect(subject.body).to eq('Not updated body. Not updated body. Not updated body.')
      end

      it "re-renders :edit view" do
        expect(response).to render_template 'edit'
      end
    end

    context "when not user's Comment" do
      it "doesn't change @comment attributes" do
        alien_comment = create(:comment, commentable: question,
          body: 'Not updated body. Not updated body.')

        patch :update, id: alien_comment, question_id: question,
          comment: attributes_for(:comment, body: 'Updated body! Updated body! Updated body!')
        alien_comment.reload

        expect(alien_comment.body).to eq('Not updated body. Not updated body.')
      end

      it "responds with 403 status" do
        alien_comment = create(:comment, commentable: question,
          body: 'Not updated body. Not updated body.')

        patch :update, id: alien_comment, question_id: question,
          comment: attributes_for(:comment, body: 'Updated body! Updated body! Updated body!')
        alien_comment.reload

        expect(response.status).to eq(403)
      end
    end

    context "when not logged in" do
      subject { create(:comment, commentable: question) }

      it "doesn't change @comment attributes" do
        original_body = subject.body
        patch :update, id: subject, question_id: question,
          comment: {body: 'Updated body! Updated body! Updated body!'}
        subject.reload
        expect(subject.body).to eq(original_body)
        expect(subject.body).to_not eq('Updated body! Updated body! Updated body!')
      end

      it "responds with 403 status" do
        patch :update, id: subject, question_id: question,
          comment: {body: 'Updated body! Updated body! Updated body!'}
        expect(response.status).to eq(403)
      end
    end
  end

  describe "DELETE #destroy" do
    before { login_user }
    let(:question) { create(:question) }

    context "when Comment owner" do
      let!(:comment) { create(:comment, user: @user, commentable: question) }

      context "with AJAX" do
        it "deletes the requested Comment" do
          expect {
            delete :destroy, id: comment, question_id: question, format: :js
          }.to change(question.comments, :count).by(-1)
        end

        it "renders :destroy view" do
          delete :destroy, id: comment, question_id: question, format: :js
          expect(response).to render_template 'destroy'
        end
      end

      context "without AJAX" do
        it "finds Comment to delete" do
          delete :destroy, id: comment, question_id: question
          expect(assigns(:comment)).to eq(comment)
        end

        it "deletes the requested Comment" do
          expect {
            delete :destroy, id: comment, question_id: question
          }.to change(question.comments, :count).by(-1)
        end

        it "redirects to Comment's Question" do
          delete :destroy, id: comment, question_id: question
          expect(response).to redirect_to question_path(comment.commentable)
        end
      end
    end

    context "when not user's Comment" do
      let!(:alien_comment) { create(:comment, commentable: question) }

      it "doesn't delete Comment from DB" do
        expect {
          delete :destroy, id: alien_comment, question_id: question
        }.to_not change(question.comments, :count)
      end

      it "responds with 403 status" do
        delete :destroy, id: alien_comment, question_id: question
        expect(response.status).to eq(403)
      end
    end

    context "when not logged in" do
      let!(:comment) { create(:comment, commentable: question) }

      it "doesn't delete Comment from DB" do
        expect {
          delete :destroy, id: comment, question_id: question
        }.to_not change(question.comments, :count)
      end

      it "responds with 403 status" do
        delete :destroy, id: comment, question_id: question
        expect(response.status).to eq(403)
      end
    end
  end
end