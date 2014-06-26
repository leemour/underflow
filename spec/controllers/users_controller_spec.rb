require 'spec_helper'

describe UsersController do
  describe "GET #show" do
    subject { create(:user) }
    before { get :show, id: subject }

    it "finds requested User" do
      expect(assigns :user).to eq(subject)
    end

    it "renders :show view" do
      expect(response).to render_template 'show'
    end
  end

  describe "GET #edit" do
    subject { create(:user) }

    context 'when this User' do
      before do
        sign_in subject
        get :edit, id: subject
      end

      it "finds requested User" do
        expect(assigns :user).to eq(subject)
      end

      it "renders :edit view" do
        expect(response).to render_template 'edit'
      end
    end

    context 'when other User' do
      before do
        login_user
        get :edit, id: subject
      end

      it { should render_template 'static/error' }
    end

    context 'when not logged in' do
      it "redirects to log in page" do
        get :edit, id: subject
        expect(request).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH #update" do
    subject do
      user = create(:user)
      user.update(profile_attributes: { real_name: 'Not updated real name'})
      user
    end

    context 'when this User' do
      before { sign_in subject }

      context "with valid attributes" do
        before do
          patch :update, id: subject, user: {
            profile_attributes: {real_name: 'New Real Name'}}
        end

        it "finds requested User" do
          expect(assigns(:user)).to eq(subject)
        end

        it "changes User real_name" do
          subject.reload
          expect(subject.real_name).to eq('New Real Name')
        end

        it "redirects to User" do
          expect(response).to redirect_to subject
        end
      end

      context "with invalid attributes" do
        before do
          patch :update, id: subject, user: {
            profile_attributes: {real_name: '&&&'}}
        end

        it "finds requested User" do
          expect(assigns(:user)).to eq(subject)
        end

        it "doesn't change User real_name" do
          subject.reload
          # expect(subject.real_name).to eq('Not updated real name')
        end

        it "renders :edit view" do
          expect(response).to render_template 'edit'
        end
      end
    end

    context 'when other User' do
      before do
        login_user
        patch :update, id: subject, user: {
          profile_attributes: {real_name: 'New Real Name'}}
      end

      it "doesn't change User real_name" do
        subject.reload
        expect(subject.real_name).to eq('Not updated real name')
      end

      it "renders :error view" do
        expect(response).to render_template 'static/error'
      end
    end

    context 'when not logged in' do
      it "redirects to log in page" do
        patch :update, id: subject, user: {
          profile_attributes: {real_name: 'New Real Name'}}
        expect(request).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'GET #reset_password' do
    subject { create(:user) }

    context 'when this User' do
      before do
        sign_in subject
        get :reset_password, id: subject
      end

      it 'sends email to user' do
        expect(last_email.to).to include(subject.email)
      end

      it 'sends email with password token' do
        expect(last_email.body).to match(/reset_password_token=.+"/)
      end
    end

    context 'when other User' do
      before do
        login_user
        get :reset_password, id: subject
      end

      it "doesn't send email to user" do
        # puts ActionMailer::Base.deliveries.last.subject
        expect(last_email.subject).to eq('Инструкции по восстановлению пароля')
        expect(last_email.to).to_not include(subject.email)
      end

      it 'renders :error view' do
        expect(response).to render_template 'static/error'
      end
    end

    context 'when not logged in' do
      it "redirects to log in page" do
        get :reset_password, id: subject
        expect(request).to redirect_to(new_user_session_path)
      end
    end
  end
end