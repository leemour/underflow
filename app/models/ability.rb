class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      user.admin? ? admin_abilities : user_abilities(user)
    else
      guest_abilities
    end
  end

  def user_abilities(user)
    guest_abilities
    alias_action :edit, :update, :destroy, to: :modify

    can :create, [Question, Answer, Comment]
    can :modify, [Question, Answer, Comment], user_id: user.id
    can [:voted, :tagged, :favorited, :by_user, :favor], Question

    can :accept, Answer do |answer|
      question = answer.question
      question.user_id == user.id &&
        (question.accepted_answer.nil? || question.accepted?(answer))
    end

    can [:create, :destroy], Bounty, question: { user_id: user.id }

    can [:reset_password, :edit, :update], User, id: user.id
    can [:up, :down], Vote do |vote|
      vote.voteable.user_id != user.id
    end
  end

  private

  def admin_abilities
    can :manage, :all
  end

  def guest_abilities
    can :read, :all
    can [:voted, :tagged, :favorited, :by_user, :favor], Question
    can [:voted, :by_user], Answer
  end
end
