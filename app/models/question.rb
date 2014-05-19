class Question < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :tags
  has_many :answers, dependent: :destroy
  has_many :comments,    as: :commentable, dependent: :destroy
  has_many :attachments, as: :attachable,  dependent: :destroy

  accepts_nested_attributes_for :attachments

  validates :title, presence: true, length: {in: 15..60}
  validates :body,  presence: true, length: {in: 60..6000}

  enum status: [:active, :locked, :flagged, :deleted, :archived]

  default_scope { order('created_at DESC') }


  def from?(user)
    user == self.user
  end
end
