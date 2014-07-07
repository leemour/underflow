shared_examples 'timestampable' do
  let(:subject_class) { described_class.name.underscore }

  describe 'self#last_timestamp' do
    let!(:objects) { create_list(subject_class, 3) }

    it "returns created_at of the last created Object" do
      objects.last.reload
      expect(described_class.last_timestamp).to eq(objects.last.created_at)
    end
  end
end