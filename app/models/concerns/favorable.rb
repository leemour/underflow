module Favorable
  extend ActiveSupport::Concern

  included do
    has_many :favorites, as: :favorable, dependent: :destroy
    scope :favorite, ->(user) { joins(:favorites).
                                 where(favorites: {user_id: user}) }
  end

  def favor(user)
    favorite = user.favorite(self)
    if favorite
      favorite.destroy
      return false
    else
      favorites.create(user: user)
    end
  end

  def favored_by?(user)
    favorites.where(user_id: user).first
  end
end