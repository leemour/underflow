class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true, length: {in: 30..6000}


  def from?(user)
    user == self.user
  end
end
