module Voteable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :voteable,  dependent: :destroy
  end

  def vote_up(user)
    vote = user.get_vote_for(self)
    if vote
      vote.destroy if vote.value == 1
      vote.update(value: 1) if vote.value == -1
    else
      self.votes.create(user: user, value: 1)
    end
  end

  def vote_down(user)
    vote = user.get_vote_for(self)
    if vote
      vote.destroy if vote.value == -1
      vote.update(value: -1) if vote.value == 1
    else
      self.votes.create(user: user, value: -1)
    end
  end

  def vote_sum
    votes.sum(:value)
  end
end
