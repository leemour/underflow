module ApplicationHelper
  def app_name
    "Stack Underflow"
  end

  def body_class
    "#{controller_name} #{action_name}"
  end
end
