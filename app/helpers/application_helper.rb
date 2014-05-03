module ApplicationHelper
  def app_name
    "Stack Underflow"
  end

  def body_class
    "#{controller_name} #{action_name}"
  end

  def created_ago(object)
    time_ago_in_words(object.created_at) unless object.created_at.blank?
  end
end
