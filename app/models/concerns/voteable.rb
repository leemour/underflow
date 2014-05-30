module Voteable
  extend ActiveSupport::Concern

  def vote_up(user)
    votes.create(user: user, value: 1)
  end

  def vote_down(user)
    votes.create(user: user, value: -1)
  end

  def rating
    votes.sum(:value)
  end
end
