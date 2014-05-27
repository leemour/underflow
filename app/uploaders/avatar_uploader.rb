class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/user/#{mounted_as}/#{model.id}"
  end

  process resize_to_fit: [512, 512]

  version :micro do
    process resize_to_fill: [16, 16]
  end

  version :thumb do
    process resize_to_fill: [32, 32]
  end

  version :medium do
    process resize_to_fill: [128, 128]
  end

  version :large do
    process resize_to_fit: [512, 512]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
