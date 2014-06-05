class Bounty < ActiveRecord::Base
  belongs_to :question
  belongs_to :winner, class_name: 'User'
  has_one :owner, through: :question, source: :user
  validates :value, numericality: {greater_than_or_equal_to: 50}

  # def self.award_to(answer)
  #   bounty = answer.question.bounty
  #   if bounty
  #     bounty.update(winner_id: answer.user.id)
  #     answer.question.user.reputation -= bounty.value
  #     answer.user.reputation += bounty.value
  #   end
  # end
end