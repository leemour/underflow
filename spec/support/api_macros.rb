module ApiMacros

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def it_includes_attributes(attributes)
      attributes.each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(
            subject.send(attr.to_sym).to_json).at_path(attr)
        end
      end
    end

    def it_excludes_attributes(*attributes)
      attributes.each do |attr|
        it "doesn't contain #{attr}" do
          expect(response.body).to be_json_eql(
            subject.send(attr).to_json).at_path(attr)
        end
      end
    end
  end
end