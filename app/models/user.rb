class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :questions
  has_many :answers
  has_many :comments

  validates :name, presence: true, uniqueness: true, length: {in: 3..30}
  validates :email, presence: true, uniqueness: true, length: {maximum: 254},
            format: {with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}
  validates :real_name, allow_blank: true, format: {with: /\A[a-z0-9\-_\w]+\Z/i}
  validates :website, allow_blank: true, format: {with: URI.regexp}
  # validates_date :birthday, on_or_before: -> { Date.current }
end
