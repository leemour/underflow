shared_examples_for "API authenticatable" do
  context 'unauthorized' do
    it 'responds with 401 status if no access token' do
      do_request
      expect(response.status).to eq(401)
    end

    it 'responds with 401 status if invalid access token' do
      do_request access_token: 'abc'
      expect(response.status).to eq(401)
    end
  end
end