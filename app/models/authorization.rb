class Authorization < ActiveRecord::Base
  belongs_to :user
  validates :uid, presence: true, uniqueness: { scope: :provider }
  validates :provider, presence: true

  def self.find_for_oauth(auth)
    find_by(provider: auth.provider, uid: auth.uid)
  end
end
