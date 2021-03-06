class Question < ActiveRecord::Base
  include Voteable
  include Favorable
  include Timestampable

  default_scope { order(created_at: :desc) }

  enum status: [:active, :locked, :flagged, :deleted, :archived]

  belongs_to :user
  has_one :bounty, dependent: :destroy
  has_and_belongs_to_many :tags
  has_many :answers, dependent: :destroy
  has_many :comments,    as: :commentable, dependent: :destroy
  has_many :attachments, as: :attachable,  dependent: :destroy
  has_many :subscriptions, as: :subscribable,  dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user,
    class_name: User

  validates :title, presence: true, length: {in: 15..60}
  validates :body,  presence: true, length: {in: 40..6000}

  after_create  :add_author_to_subscribers
  before_destroy :decrement_tags_counter

  paginates_per 5

  is_impressionable counter_cache: true, column_name: :views_count, unique: true

  accepts_nested_attributes_for :attachments, allow_destroy: true,
    reject_if: :all_blank

  scope :unanswered, -> { where(answers_count: 0) }
  scope :popular,    -> { reorder(views_count: :desc) }
  scope :featured,   -> { joins(:bounty).where(bounties: {winner_id: nil}).
                          order('bounties.value') }
  scope :most_voted, -> { joins("LEFT OUTER JOIN votes ON "\
                          "questions.id = votes.voteable_id AND "\
                          "votes.voteable_type = 'Question'").
                          group('questions.id').
                          reorder('COALESCE(SUM(votes.value), 0) desc') }

  def self.favorited(user_id)
    joins(:favorites).where(favorites: {user_id: user_id})
  end

  def from?(user)
    user == self.user
  end

  def tag_list
    tags.pluck(:name)
  end

  def tag_list=(tags)
    new_tags = [*tags].map {|t| Tag.find_or_create_by(name: t.downcase.strip) }
    new_tags.each do |t|
      unless self.tags.include? t
        self.tags << t
        t.increment!(:questions_count)
      end
    end
    self.tags.each do |t|
      unless new_tags.include? t
        self.tags.delete(t)
        t.decrement!(:questions_count)
      end
    end
  end

  def accepted_answer
    answers.find_by_accepted(true)
  end

  def accepted?(answer)
    accepted_answer == answer
  end

  def subscribe(user)
    subscription = Subscription.new(user: user, subscribable: self)
    subscription.save!
    subscription
  end

  def unsubscribe(user)
    Subscription.delete_all(user: user, subscribable: self)
  end

  protected

  def add_author_to_subscribers
    subscribe(self.user)
  end

  def decrement_tags_counter
    self.tags.each {|t| t.decrement!(:questions_count) }
  end
end
