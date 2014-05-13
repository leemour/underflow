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

  def tr(model, action)
    { notice: t("model_#{action}",
          model: t("activerecord.models.#{model}", count: 1)) }
  end
end
