class User < ActiveRecord::Base
  AVATAR_SIZE = { micro: 16, thumb: 32, medium: 128, large: 512 }

  default_scope { order('reputation ASC, created_at DESC') }

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable,
         omniauth_providers: [:facebook, :twitter]

  has_one :profile, dependent: :destroy
  has_many :questions
  has_many :answers
  has_many :comments
  has_many :votes
  has_many :voted_questions, through: :votes, source: :voteable,
    source_type: "Question"
  has_many :voted_answers, through: :votes, source: :voteable,
    source_type: "Answer"
  has_many :favorites, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  attr_accessor :login

  accepts_nested_attributes_for :profile

  delegate :real_name, :website, :location, :birthday, :about, to: :profile

  validates :name, presence: true, uniqueness: {case_sensitive: false},
    length: {in: 3..30}
  validates :email, uniqueness: { case_sensitive: false },
    length: {maximum: 254}, format: {with: Devise.email_regexp}

  after_create :set_profile

  mount_uploader :avatar, AvatarUploader

  paginates_per 5

  # Authenticate by email or login
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def self.find_for_oauth(auth, current_user=nil)
    authorization = Authorization.find_for_oauth(auth)
    return authorization.user if authorization

    email = auth.info.email
    return User.new unless email

    user = User.find_by_email(email)
    if user.nil?
      password = Devise.friendly_token[0,10]
      name = User.unique_name(auth.info.nickname)
      user = User.create! name: name, email: email, password: password,
        password_confirmation: password
    end

    user.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
    user
  end

  def self.build_from_email_and_session(params, session)
    name = User.unique_name session.info.nickname
    password = Devise.friendly_token[0,10]
    user = User.new(email: params[:email],  name: name, password: password,
      password_confirmation: password)
    user.authorizations.build(provider: session.provider, uid: session.uid.to_s)
    user
  end

  def self.unique_name(name)
    unique_name = name
    i = 2
    while find_by_name(unique_name) do
      unique_name = name + i.to_s
      i += 1
    end
    unique_name
  end

  def self.send_daily_digest
    select(:id).find_each do |user|
      DailyMailer.delay.digest(user.id) if user.try(:daily_digest)
    end
  end


  def create_authorization(auth)
    authorizations.find_or_create_by(uid: auth.uid, provider: auth.provider)
  end

  def set_profile
    self.create_profile
  end

  def login=(login)
    @login = login
  end

  def login
    @login || self.name || self.email
  end

  def subscribed_to?(resource)
    !!Subscription.where(user: self, subscribable: resource).first
  end

  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  def voted(object)
    votes = {1 => :up,-1 => :down}
    votes[get_vote_for(object).try(:value)]
  end

  def get_vote_for(object)
    votes.where(voteable_id: object.id, voteable_type: object.class).first
  end

  def favorited(object)
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