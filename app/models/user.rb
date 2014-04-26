class User < ActiveRecord::Base
  has_many :questions

  validates_presence_of :name, :email
  validates_length_of   :name, in: 3..30
  # validates_date        :birthday, on_or_before: -> { Date.current }
end
