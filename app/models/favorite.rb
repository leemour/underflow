class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :favorable, polymorphic: true
end
