class Comment < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  belongs_to :commentable, polymorphic: true

  validates :body, presence: true, length: {in: 15..500}
end
