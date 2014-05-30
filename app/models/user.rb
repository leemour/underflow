class User < ActiveRecord::Base
  default_scope { order('name ASC') }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :profile
  has_many :questions
  has_many :answers
  has_many :comments
  has_many :comments
  has_many :votes
  has_many :voted_questions, through: :votes, source: :voteable,
    source_type: "Question"
  has_many :voted_answers, through: :votes, source: :voteable,
    source_type: "Answer"

  accepts_nested_attributes_for :profile

  delegate :real_name, :website, :location, :birthday, :about, :avatar_url,
    to: :profile

  validates :name, presence: true, uniqueness: true, length: {in: 3..30}
  validates :email, length: {maximum: 254}, format: {with: Devise.email_regexp}

  after_create :set_profile

  def set_profile
    self.create_profile
  end

  # def profile
  #   super || self.create_profile
  # end

  def voted_for?(object)
    voteables = object.class.to_s.underscore.pluralize
    send("voted_#{voteables}").include?(object)
  end
end

# u = FactoryGirl.create(:user)
# q = FactoryGirl.create(:question)
# q.vote_up(u)
# u.voted_questions

# Question.delete_all
# User.delete_all