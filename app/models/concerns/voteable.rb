module Voteable
  extend ActiveSupport::Concern

  def vote_up(user)
    vote = user.vote(self)
    if vote
      vote.destroy if vote.value == 1
      vote.update(value: 1) if vote.value == -1
    else
      self.votes.create(user: user, value: 1)
    end
  end

  def vote_down(user)
    vote = user.vote(self)
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
