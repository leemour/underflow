class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  has_many :comments, as: :commentable

  validates :body, presence: true, length: {in: 50..6000}
end
