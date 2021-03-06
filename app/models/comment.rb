class Comment < ActiveRecord::Base
  default_scope { order('created_at ASC') }

  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates :body, presence: true, length: {in: 15..500}

  def from?(user)
    user == self.user
  end
end
