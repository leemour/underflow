module ApplicationHelper
  def app_name
    "Underflow"
  end

  def body_class
    "#{controller_name} #{action_name}"
  end

  def created_ago(object)
    unless object.created_at.blank?
      time_ago_in_words(object.created_at) + " #{t('time.ago')}"
    end
  end

  def time_distance_ago(time_from)
    unless time_from.blank?
      distance_of_time_in_words_to_now(time_from) + " #{t('time.ago')}"
    end
  end

  def tr(model, action)
    { notice: t("model.#{action}",
          model: t("activerecord.models.#{model}", count: 1)) }
  end

  def item_class(item)
    "own" if user_signed_in? && current_user == item.user
  end

  def class_with_id(object)
    "#{object.class.to_s.underscore}-#{object.id}"
  end

  # def accept_link_class(question, answer)
  #   link_class = 'accept'
  #   link_class += ' hidden' unless accepted_answer_or_no_answers_accepted(question, answer)
  #   link_class += ' accepted' if question.accepted?(answer)
  # end

  # def accepted_answer_or_no_answers_accepted(question, answer)
  #   (question.accepted_answer && question.accepted?(answer)) || !question.accepted_answer
  # end

  def accept_link_class(question, answer)
    link_class = 'accept'
    link_class += ' hidden' if other_than_accepted_answer(question, answer)
    link_class += ' accepted' if question.accepted?(answer)
    link_class
  end

  def other_than_accepted_answer(question, answer)
    !question.accepted?(answer) && question.accepted_answer
  end
end
