class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_and_belongs_to_many :tags

  validates :title, presence: true, length: {in: 15..60}
  validates :body,  presence: true, length: {in: 60..6000}

  enum status: [:active, :locked, :flagged, :deleted, :archived]


  def from?(user)
    user == self.user
  end
end
