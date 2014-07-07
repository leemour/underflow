require 'spec_helper'

describe 'Users API' do
  describe 'Resource Owner Profile' do
    context 'unauthorized' do
      it 'responds with 401 status if no access token' do
        get '/api/v1/users/me', format: :json
        expect(response.status).to eq(401)
      end

      it 'responds with 401 status if invalid access token' do
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

      # subject { me }

      # it_includes_attributes %w[name email]

      %w[id email created_at updated_at].each do |attr|
        it "contains User #{attr}" do
          expect(response.body).to be_json_eql(
            me.send(attr.to_sym).to_json).at_path("user/#{attr}")
        end
      end

      %w[password encrypted_password admin].each do |attr|
        it "doesn't contain User #{attr}" do
          expect(response.body).to_not have_json_path("user/#{attr}")
        end
      end
    end
  end

  describe 'All User profiles' do
    context 'unauthorized' do
      it 'responds with 401 status if no access token' do
        get '/api/v1/users', format: :json
        expect(response.status).to eq(401)
      end

      it 'responds with 401 status if invalid access token' do
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
        expect(response.status).to eq(200)
      end

      context 'contains' do
        %w[id name email created_at updated_at].each do |attr|
          it "first User contains #{attr}" do
            expect(response.body).to be_json_eql(
              me.send(attr.to_sym).to_json).at_path("users/0/#{attr}")
          end
        end

        # it "first User contains avatar" do
        #   # expect(me.avatar.to_json).to eq 0
        #   expect(response.body).to be_json_eql(
        #     me.avatar.to_json).at_path("0/avatar")
        # end
      end


      %w[id name email created_at updated_at].each do |attr|
        it "second User contains #{attr}" do
          expect(response.body).to be_json_eql(
            user.send(attr.to_sym).to_json).at_path("users/1/#{attr}")
        end
      end

      context 'with Profile' do
        %w[real_name location website birthday about].each do |attr|
          it "first User contains #{attr}" do
            expect(response.body).to be_json_eql(
              me.send(attr.to_sym).to_json).at_path("users/0/profile/#{attr}")
          end
        end

        %w[real_name location website birthday about].each do |attr|
          it "second User contains #{attr}" do
            expect(response.body).to be_json_eql(
              user.send(attr.to_sym).to_json).at_path("users/1/profile/#{attr}")
          end
        end
      end

      context "doesn't contain" do
        %w[password encrypted_password admin].each do |attr|
          it "first User doesn't contain #{attr}" do
            expect(response.body).to_not have_json_path("users/0/#{attr}")
          end

          it "second User doesn't contain #{attr}" do
            expect(response.body).to_not have_json_path("users/1/#{attr}")
          end
        end
      end
    end
  end
end