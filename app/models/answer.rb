class Answer < ActiveRecord::Base
  include Voteable

  default_scope { order('created_at ASC') }
  scope :accepted_first, -> { reorder('accepted DESC, created_at ASC') }

  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :votes, as: :voteable,  dependent: :destroy

  accepts_nested_attributes_for :attachments, allow_destroy: true,
    reject_if: :all_blank

  validates :body, presence: true, length: {in: 30..6000}

  def from?(user)
    user == self.user
  end
end
