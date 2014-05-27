class Profile < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :user

  validates :real_name, allow_blank: true, length: {in: 3..40},
    format: {with: /\A[а-яa-z0-9\.\-_\s]+\Z/i}
  validates :website, allow_blank: true, format: {with: URI.regexp}
  # validates_date :birthday, on_or_before: -> { Date.current }

  mount_uploader :avatar, AvatarUploader

  def avatar_url(size=:thumb)
    avatar.url ? avatar.url(size) : gravatar_url(size)
  end

  def gravatar_url(size)
    # default_url = "#{root_url}/images/avatar-default.jpg"
    default_url = "http://riabit.ru/avatar-default-#{size}.jpg"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = avatar_size_in_pixels(size)
    "http://gravatar.com/avatar/#{gravatar_id}.png?"\
      "s=#{size}&d=#{CGI.escape(default_url)}"
  end

  def avatar_size_in_pixels(size)
    case size
    when :micro  then 16
    when :thumb  then 32
    when :medium then 128
    when :large  then 512
    end
  end
end
