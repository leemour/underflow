require 'spec_helper'

describe BountiesController do

  describe "POST #start" do
    context 'when Question author' do
      before { login_user }
      let(:question) { create(:question, user: @user) }

      context "with AJAX" do
        before { post :start, id: question, bounty: attributes_for(:bounty),
          format: :js }

        it "creates Bounty with value 50" do
          assigns(:question).reload
          expect(assigns(:question).bounty.value).to eq(50)
        end

        it "renders :start view" do
          expect(response).to render_template 'start'
        end
      end

      context "without AJAX" do
        before { post :start, id: question, bounty: attributes_for(:bounty) }

        it "creates Bounty with value 50" do
          assigns(:question).reload
          expect(assigns(:question).bounty.value).to eq(50)
        end

        it "redirects to question page" do
          expect(response).to redirect_to(question_path(question))
        end
      end
    end

    context 'when not Question author' do
      before { login_user }
      let(:question) { create(:question) }
      before { post :start, id: question, bounty: attributes_for(:bounty) }

      it "doesn't create bounty" do
        expect(assigns(:question).bounty).to be_nil
      end

      it "responds with 403 status" do
        expect(response.status).to eq(403)
      end
    end

    context 'when not logged in' do
      let(:question) { create(:question) }
      before { post :start, id: question, bounty: attributes_for(:bounty) }

      it "doesn't create bounty" do
        expect(assigns(:question)).to be_nil
      end

      it "redirects to login page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE #stop" do
    context 'when Question author' do
      before { login_user }
      let(:question) { create(:question, user: @user) }
      before { create(:bounty, question: question) }
      before { delete :stop, id: question}

      it "deletes bounty from Question" do
        assigns(:question).reload
        expect(assigns(:question).bounty).to be_nil
      end

      it "redirects to question page" do
        expect(response).to redirect_to(question_path(question))
      end
    end

    context 'when not Question author' do
      before { login_user }
      let(:question) { create(:question) }
      before { delete :stop, id: question }

      it "doesn't create bounty" do
        expect(assigns(:question).bounty).to be_nil
      end

      it "responds with 403 status" do
        expect(response.status).to eq(403)
      end
    end

    context 'when not logged in' do
      let(:question) { create(:question) }
      before { delete :stop, id: question }

      it "doesn't create bounty" do
        expect(assigns(:question)).to be_nil
      end

      it "redirects to login page" do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end