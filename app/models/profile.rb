class Profile < ActiveRecord::Base
  belongs_to :user

  validates :real_name, allow_blank: true, length: {in: 3..40},
    format: {with: /\A[а-яa-z0-9\.\-_\s]+\Z/i}
  validates :website, allow_blank: true, format: {with: URI.regexp}
  # validates_date :birthday, on_or_before: -> { Date.current }
end