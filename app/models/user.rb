class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one  :profile
  has_many :questions
  has_many :answers
  has_many :comments

  delegate :real_name, :website, :location, :birthday, :about, to: :profile

  validates :name, presence: true, uniqueness: true, length: {in: 3..30}
  validates :email, length: {maximum: 254}, format: {with: Devise.email_regexp}

  def profile
    super || self.create_profile
  end
end
