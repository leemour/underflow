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
    before { get :edit, id: subject }

    it "finds requested User" do
      expect(assigns :user).to eq(subject)
    end

    it "renders :edit view" do
      expect(response).to render_template 'edit'
    end
  end

  describe "GET #update" do
    subject { create(:user) }
    before do
      subject.update(profile_attributes: {real_name: 'Not updated real name'})
    end

    context "with valid attributes" do
      before do
        patch :update, id: subject, user: {
          profile_attributes: {real_name: 'New Real Name'}}
      end

      it "finds requested User" do
        expect(assigns(:user)).to eq(subject)
      end

      it "changes User real_name" do
        assigns(:user).reload
        expect(assigns(:user).real_name).to eq('New Real Name')
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
        assigns(:user).reload
        # expect(assigns(:user).real_name).to eq('Not updated real name')
      end

      it "renders :edit view" do
        expect(response).to render_template 'edit'
      end
    end
  end
end