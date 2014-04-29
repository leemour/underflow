class Comment < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  belongs_to :commentable, polymorphic: true, dependent: :destroy

  validates :body, presence: true, length: {in: 15..500}
end
