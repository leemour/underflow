require 'spec_helper'

describe OmniauthCallbacksController do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
    OmniAuth.config.test_mode = true
  end

  # def stub_env_for_omniauth(provider)
  #   request.env["omniauth.auth"] = OmniAuth.config.mock_auth[provider]
  # end

  describe '#facebook' do
    before do
      OmniAuth.config.add_mock :facebook, provider: :facebook,
        uid: "1234", info: {email: "ghost@nobody.com"},
        extra: { raw_info: { name: 'name' } }
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    end

    context "when user exists" do
      let!(:user) { create(:user, email: "ghost@nobody.com") }
      before { get :facebook }

      it "finds user" do
        expect(assigns(:user)).to eq(user)
      end

      it "signs in user" do
        expect(subject.current_user).to eq(user)
      end

      it 'redirects to home page' do
        expect(response).to redirect_to root_path
      end
    end

    context "when new user" do
      it "creates user" do
        expect { get :facebook }.to change(User,:count).by(1)
      end

      it "fills new user email" do
        get :facebook
        expect(assigns(:user).email).to eq("ghost@nobody.com")
      end

      it "signs in user" do
        get :facebook
        expect(subject.current_user).to eq(assigns(:user))
      end

      it 'redirects to home page' do
        get :facebook
        expect(response).to redirect_to root_path
      end
    end
  end
end
