class Tag < ActiveRecord::Base
  has_and_belongs_to_many :questions

  validates :name, presence: true, length: {in: 2..30}
  validates :excerpt, length: {in: 15..500}
  validates :description, presence: true, length: {in: 100..6000}
end
