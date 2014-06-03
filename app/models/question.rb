class Question < ActiveRecord::Base
  include Voteable
  include Favorable

  default_scope { order('created_at DESC') }

  belongs_to :user
  has_and_belongs_to_many :tags
  has_many :answers, dependent: :destroy
  has_many :comments,    as: :commentable, dependent: :destroy
  has_many :attachments, as: :attachable,  dependent: :destroy

  is_impressionable counter_cache: true, column_name: :views_count, unique: true

  accepts_nested_attributes_for :attachments, allow_destroy: true,
    reject_if: :all_blank

  validates :title, presence: true, length: {in: 15..60}
  validates :body,  presence: true, length: {in: 60..6000}

  enum status: [:active, :locked, :flagged, :deleted, :archived]

  def from?(user)
    user == self.user
  end

  def tag_list
    tags.pluck(:name)
  end

  def tag_list=(tags)
    tags = tags.split(',') if tags.is_a? String
    new_tags = [*tags].map {|t| Tag.find_or_create_by(name: t.downcase.strip) }
    new_tags.each {|t| self.tags << t unless self.tags.include? t }
    self.tags.each {|t| self.tags.delete(t) unless new_tags.include? t }
  end

  def accepted_answer
    answers.find_by_accepted(true)
  end

  def accepted?(answer)
    accepted_answer == answer
  end
end
