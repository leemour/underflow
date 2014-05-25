class FileUploader < CarrierWave::Uploader::Base
  delegate :filename, to: :file, allow_nil: true

  storage :file

  def store_dir
    if Rails.env.test? || Rails.env.cucumber?
      "uploads/#{model.class.to_s.underscore}/test/"\
      "#{model.attachable.class.to_s.underscore}-#{model.attachable.id}"
    else
      "uploads/#{model.class.to_s.underscore}/"\
      "#{model.attachable.class.to_s.underscore}-#{model.attachable.id}"
    end
  end
end
