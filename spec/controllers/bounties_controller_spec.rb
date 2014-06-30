require 'spec_helper'

describe BountiesController do

  describe "POST #create" do
    context 'when Question author' do
      before { login_user }
      let(:question) { create(:question, user: @user) }

      context "with AJAX" do
        before do
          post :create, question_id: question,
            bounty: attributes_for(:bounty), format: :js
        end

        it "creates Bounty with value 50" do
          assigns(:question).reload
          expect(assigns(:question).bounty.value).to eq(50)
        end

        it "renders :create view" do
          expect(response).to render_template 'create'
        end
      end

      context "without AJAX" do
        before { post :create, question_id: question, bounty: attributes_for(:bounty) }

        it "creates Bounty with value 50" do
          assigns(:question).reload
          expect(assigns(:question).bounty.value).to eq(50)
        end

        it "redirects to question page" do
          expect(response).to redirect_to(question_path(question))
        end
      end

      context 'Question with Bounty' do
        before do
          create(:bounty, question: question, value: 300)
          post :create, question_id: question,
            bounty: attributes_for(:bounty), format: :js
        end

        it "doesn't update existing Bounty" do
          assigns(:question).reload
          expect(assigns(:question).bounty.value).to eq(300)
        end

        it "renders :error view" do
          expect(response).to render_template 'static/error'
        end
      end
    end

    context 'when not Question author' do
      before { login_user }
      let(:question) { create(:question) }
      before { post :create, question_id: question, bounty: attributes_for(:bounty) }

      it "doesn't create bounty" do
        assigns(:question).reload
        expect(assigns(:question).bounty).to be_nil
      end

      it "responds with 403 status" do
        expect(response.status).to eq(403)
      end

      it "renders :error view" do
        expect(response).to render_template 'static/error'
      end
    end

    context 'when not logged in' do
      let(:question) { create(:question) }
      before { post :create, question_id: question, bounty: attributes_for(:bounty) }

      it "doesn't create bounty" do
        expect(assigns(:question)).to be_nil
      end

      it "redirects to login page" do
        expect(response.status).to redirect_to(new_user_session_path)
      end

      it "redirects to login page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context 'when Question author' do
      before { login_user }
      let(:question) { create(:question, user: @user) }
      let!(:bounty) { create(:bounty, question: question) }
      before { delete :destroy, question_id: question}

      it "deletes bounty from Question" do
        assigns(:question).reload
        expect(assigns(:question).bounty).to be_nil
      end

      it "redirects to question page" do
        expect(response).to redirect_to(question_path(question))
      end

      context 'Question without Bounty' do
        before do
          question = create(:question)
          post :create, question_id: question,
            bounty: attributes_for(:bounty), format: :js
        end

        it "doesn't find Bounty" do
          assigns(:question).reload
          expect(assigns(:question).bounty).to be_nil
        end

        it "renders :error view" do
          expect(response).to render_template 'static/error'
        end
      end
    end

    context 'when not Question author' do
      before { login_user }
      let(:question) { create(:question) }
      let!(:bounty) { create(:bounty, question: question) }
      before { delete :destroy, question_id: question }

      it "doesn't delete bounty" do
        assigns(:question).reload
        expect(assigns(:question).bounty).to eq(bounty)
      end

      it "responds with 403 status" do
        expect(response.status).to eq(403)
      end
    end

    context 'when not logged in' do
      let(:question) { create(:question) }
      before { delete :destroy, question_id: question }

      it "doesn't create bounty" do
        expect(assigns(:question)).to be_nil
      end

      it "redirects to login page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end