class Bounty < ActiveRecord::Base
  belongs_to :question
  belongs_to :winner, class: User
  has_one :owner, through: :question, source: :user
  validates :value, numericality: {greater_than_or_equal_to: 50}
end