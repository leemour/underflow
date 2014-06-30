module ApiMacros
  def includes(*attributes)
    attributes.each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(
          subject.send(attr.to_sym).to_json).at_path(attr)
      end
    end
  end

  def excludes(*attributes)
    attributes.each do |attr|
      it "doesn't contain #{attr}" do
        expect(response.body).to be_json_eql(
          subject.send(attr).to_json).at_path(attr)
      end
    end
  end
end