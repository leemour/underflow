class Question < ActiveRecord::Base
  include Voteable
  include Favorable

  default_scope { order(created_at: :desc) }

  enum status: [:active, :locked, :flagged, :deleted, :archived]

  belongs_to :user
  has_one :bounty, dependent: :destroy
  has_and_belongs_to_many :tags
  has_many :answers, dependent: :destroy
  has_many :comments,    as: :commentable, dependent: :destroy
  has_many :attachments, as: :attachable,  dependent: :destroy

  validates :title, presence: true, length: {in: 15..60}
  validates :body,  presence: true, length: {in: 60..6000}

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

  def self.last_timestamp
    reorder('created_at DESC').limit(1).first.created_at
  end

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

  protected

  def decrement_tags_counter
    self.tags.each {|t| t.decrement!(:questions_count) }
  end
end
