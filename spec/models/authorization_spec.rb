require 'spec_helper'

describe Authorization do
  it { should belong_to :user }
  it { should validate_presence_of :uid }
  it { should validate_presence_of :provider }
  it { should validate_uniqueness_of :uid }

  describe 'self#find_for_oauth' do
    let(:auth_params) { { uid: '1234', provider: 'facebook' } }
    let(:auth) { OmniAuth::AuthHash.new auth_params }

    it 'returns Authorization if it exists' do
      authorization = create(:authorization, auth_params)
      expect(Authorization.find_for_oauth(auth)).to eq(authorization)
    end

    it "returns nil if Authorization doesnt't exist" do
      expect(Authorization.find_for_oauth(auth)).to be_nil
    end
  end
end
