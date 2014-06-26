module Reputation
  VALUES = {
    vote_up: { question: 2, answer: 1 },
    vote_down: { question: -2, answer: -1 },
    answer: { normal: 1, first: 1, accepted: 3, own: 1 },
  }

  class << self
    def created_answer(answer)
      delta = reputation_delta(answer)
      answer.user.reputation += delta
      answer.user.save
    end

    def voted(vote)
      action = vote.value == 1 ? :vote_up : :vote_down
      voteable = vote.voteable.class.name.underscore.to_sym
      user = vote.voteable.user
      user.reputation += VALUES[action][voteable]
      user.save
    end

    def accepted_answer(answer, accepted)
      value = VALUES[:answer][:accepted]
      value = -value unless accepted
      answer.user.reputation += value
      answer.user.save
    end

    private

    def reputation_delta(answer)
      question = answer.question
      delta = VALUES[:answer][:normal]
      delta += VALUES[:answer][:first] if question.answers.first == answer
      delta += VALUES[:answer][:own] if question.user == answer.user
      delta
    end
  end
end