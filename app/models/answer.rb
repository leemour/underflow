class Answer < ActiveRecord::Base
  include Voteable

  default_scope { order(created_at: :asc) }
  scope :accepted_first, -> { reorder('accepted DESC, created_at ASC') }

  belongs_to :user
  belongs_to :question, counter_cache: true, touch: true
  has_one :bounty, foreign_key: 'winner_id'
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy

  accepts_nested_attributes_for :attachments, allow_destroy: true,
    reject_if: :all_blank

  validates :body, presence: true, length: {in: 30..6000}

  paginates_per 5

  def from?(user)
    user == self.user
  end

  def toggle_accepted_from(question)
    toggle(:accepted).save
    toggle_bounty_from question
  end

  private

  def toggle_bounty_from(question)
    return false unless question.bounty
    if self.user == question.bounty.winner # Already received bounty
      give_bounty_back_to(question)
    else
      receive_bounty_from(question)
    end
  end

  def receive_bounty_from(question)
    bounty = question.bounty
    bounty.update(winner_id: self.user.id)
    question.user.reputation -= bounty.value
    self.user.reputation     += bounty.value
  end

  def give_bounty_back_to(question)
    bounty = question.bounty
    bounty.update(winner_id: nil)
    question.user.reputation += bounty.value
    self.user.reputation     -= bounty.value
  end
end
