shared_examples 'favorable' do
  let(:subject_class) { described_class.name.underscore }

  describe '#favor' do
    subject { create(subject_class) }
    let(:user) { create(:user) }

    it 'returns a Favorite' do
      expect(subject.favor(user)).to be_a(Favorite)
    end

    context 'if not favourite' do
      it 'adds Object to User favourites' do
        expect {
          subject.favor(user)
        }.to change(subject.favorites, :count).by(1)
      end

      it "isn't favored by User anymore" do
        subject.favor(user)
        expect(subject).to be_favored_by user
      end
    end

    context 'if already favourite' do
      before { subject.favor(user) }

      it 'removes Object from User favourites' do
        expect {
          subject.favor(user)
        }.to change(subject.favorites, :count).by(-1)
      end

      it "isn't favored by User anymore" do
        subject.favor(user)
        expect(subject).to_not be_favored_by user
      end
    end
  end

  describe '#favored_by?' do
    subject { create(subject_class) }
    let(:user) { create(:user) }

    it 'returns false if User not favoured' do
      expect(subject).to_not be_favored_by(user)
    end

    it 'returns true if User favoured' do
      subject.favor(user)
      expect(subject).to be_favored_by(user)
    end
  end

  describe 'scopes' do
    let!(:subject1) { create(subject_class) }
    let!(:subject2) { create(subject_class) }
    let!(:subject3) { create(subject_class) }

    describe '#self.favorite' do
      let(:user1) { create(:user)}
      let(:user2) { create(:user)}
      before do
        create(:favorite, favorable: subject1, user: user1)
        create(:favorite, favorable: subject2, user: user2)
        create(:favorite, favorable: subject3, user: user1)
      end

      it 'returns Objects favored by particular User' do
        expect(described_class.favorite(user1.id)).
          to match_array [subject1, subject3]
      end
    end
  end
end