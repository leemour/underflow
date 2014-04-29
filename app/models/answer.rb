class Answer < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  belongs_to :question, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true, length: {in: 50..6000}
end
