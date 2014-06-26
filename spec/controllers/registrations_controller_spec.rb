require 'spec_helper'

describe RegistrationsController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe 'GET #enter_email' do
    before { get :enter_email }

    it 'assigns new User to @user' do
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders devise/registrations/enter_email view' do
      expect(response).to render_template 'devise/registrations/enter_email'
    end
  end

  describe 'POST #sign_up_with_email' do
    let(:auth_params) do
      { provider: 'twitter', uid: "12345", info: {nickname: 'ghost'} }
    end
    let(:session) do
      {'devise.social_data' => OmniAuth::AuthHash.new(auth_params) }
    end

    context 'with valid email' do
      before do
        post :sign_up_with_email, {user: {email: '123@mail.ru'} }, session
      end

      it 'assigns new User with email and nickname to @user' do
        expect(assigns(:user).name).to eq('ghost')
        expect(assigns(:user).email).to eq('123@mail.ru')
      end

      it 'saves @user' do
        expect(assigns(:user)).to be_persisted
      end

      it 'creates User Authorization with uid & provider' do
        authorization = assigns(:user).authorizations.last
        expect(authorization.uid).to eq(auth_params[:uid])
        expect(authorization.provider).to eq(auth_params[:provider])
      end

      it 'redirects to root' do
        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid email' do
      before do
        post :sign_up_with_email, {user: {email: ''} }, session
      end

      it "doesn't save User" do
        expect(assigns(:user)).to_not be_persisted
      end

      it "doesn't create User Authorization" do
        expect(assigns(:user).authorizations.first).to_not be_persisted
      end

      it 'renders devise/registrations/enter_email view' do
        expect(response).to render_template 'devise/registrations/enter_email'
      end
    end
  end
end