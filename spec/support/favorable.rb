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
    end

    context 'if already favourite' do
      it 'removes Object from User favourites' do
        subject.favor(user)
        expect {
          subject.favor(user)
        }.to change(subject.favorites, :count).by(-1)
      end
    end
    # expect { subject.favor(user) }.to be_favored_by user
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
end