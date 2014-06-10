class User < ActiveRecord::Base
  AVATAR_SIZE = { micro: 16, thumb: 32, medium: 128, large: 512 }

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
  has_many :favorites

  accepts_nested_attributes_for :profile

  delegate :real_name, :website, :location, :birthday, :about, to: :profile

  validates :name, presence: true, uniqueness: true, length: {in: 3..30}
  validates :email, length: {maximum: 254}, format: {with: Devise.email_regexp}

  after_create :set_profile

  mount_uploader :avatar, AvatarUploader

  paginates_per 5

  def set_profile
    self.create_profile
  end

  def voted(object)
    votes = {1 => :up,-1 => :down}
    votes[get_vote_for(object).try(:value)]
  end

  def get_vote_for(object)
    votes.where(voteable_id: object.id, voteable_type: object.class).first
  end

  def favorite(object)
    favorites.where(favorable_id: object.id, favorable_type: object.class).first
  end

  def avatar_url(size=:thumb)
    avatar.url ? avatar.url(size) : gravatar_url(size)
  end

  private

  def gravatar_url(size)
    # default_url = "#{root_url}/images/avatar-default-#{AVATAR_SIZE[size]}.jpg"
    default_url = "http://riabit.ru/avatar-default-#{AVATAR_SIZE[size]}.jpg"
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?"\
      "s=#{AVATAR_SIZE[size]}&d=#{CGI.escape(default_url)}"
  end
end