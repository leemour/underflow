class Question < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  has_many :answers
  has_many :comments, as: :commentable
  has_and_belongs_to_many :tags

  validates :title, presence: true, length: {in: 15..60}
  validates :body,  presence: true, length: {in: 100..6000}

  enum status: [:active, :locked, :flagged, :deleted, :archived]
end
