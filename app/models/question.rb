class Question < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :title, :body
  validates_length_of   :title, in: 15..60
  validates_length_of   :body,  in: 100..6000

  enum status: [:active, :locked, :flagged, :deleted, :archived]
end
