class ReputationObserver < ActiveRecord::Observer
  observe :question, :answer, :vote

  def after_create(record)
    case record.class.to_s
    when 'Answer'
      Reputation.created_answer(record)
    when 'Vote'
      Reputation.voted(record)
    end
  end

  def before_update(record)
    if record.is_a?(Answer)
      old = Answer.find(record.id)
      if record.accepted? && old && !old.accepted?
        Reputation.accepted_answer(record, true)
      elsif !record.accepted? && old && old.accepted?
        Reputation.accepted_answer(record, false)
      end
    end
  end
end