class Bounty < ActiveRecord::Base
  belongs_to :question
  has_one :owner, through: :question, source: :user
  validates_numericality_of :value, greater_than_or_equal_to: 50
end