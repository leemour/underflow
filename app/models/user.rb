class User < ActiveRecord::Base
  has_many :questions
  has_many :answers

  validates :name, presence: true, length: {in: 3..30}
  validates :email, presence: true, length: {maximum: 254},
            format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
  validates :real_name, format: {with: /\A[a-z0-9\-_\w]+\Z/i}
  validates :website, format: {with: URI.regexp}
  # validates_date :birthday, on_or_before: -> { Date.current }
end
