require 'spec_helper'

describe 'Users API' do
  describe 'Resource Owner Profile' do
    context 'unauthorized' do
      it 'responds with 401 status' do
        get '/api/v1/users/me', format: :json
        expect(response.status).to eq(401)
      end
    end

    context 'invalid access token' do
      it 'responds with 401 status' do
        get '/api/v1/users/me', format: :json, access_token: 'abc'
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      before do
        get '/api/v1/users/me', format: :json, access_token: access_token.token
      end

      it 'responds with 200 status' do
        expect(response.status).to eq(200)
      end

      %w[id email created_at updated_at].each do |attr|
        it "contains User #{attr}" do
          expect(response.body).to be_json_eql(
            me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w[password encrypted_password admin].each do |attr|
        it "doesn't contain User #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'All User profiles' do
    context 'unauthorized' do
      it 'responds with 401 status' do
        get '/api/v1/users', format: :json
        expect(response.status).to eq(401)
      end
    end

    context 'invalid access token' do
      it 'responds with 401 status' do
        get '/api/v1/users', format: :json, access_token: 'abc'
        expect(response.status).to eq(401)
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }
      let!(:user) { create(:user) }
      before do
        get '/api/v1/users', format: :json, access_token: access_token.token
      end

      it 'responds with 200 status' do
        expect(response.body).to be_json_eql(
            me.email.to_json).at_path("0/email")
        expect(response.status).to eq(200)
      end

      %w[id email created_at updated_at].each do |attr|
        it "first User contains #{attr}" do
          expect(response.body).to be_json_eql(
            me.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end

      %w[id email created_at updated_at].each do |attr|
        it "second User contains #{attr}" do
          expect(response.body).to be_json_eql(
            user.send(attr.to_sym).to_json).at_path("1/#{attr}")
        end
      end

      %w[password encrypted_password admin].each do |attr|
        it "first User doesn't contain #{attr}" do
          expect(response.body).to_not have_json_path("0/#{attr}")
        end

        it "second User doesn't contain #{attr}" do
          expect(response.body).to_not have_json_path("1/#{attr}")
        end
      end
    end
  end
end