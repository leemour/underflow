class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :resource, :resource_name, :devise_mapping


  # alias_method :devise_current_user, :current_user
  # def current_user
  #   @current_user ||= devise_current_user
  #   @current_user ||= guest_user
  # end

  # def guest_user
  #   guest = OpenStruct.new
  #   guest.instance_eval do
  #     def method_missing(meth, *args, &blk)
  #       nil
  #     end
  #   end
  # end

  protected

  def render_error(message, status=:forbidden)
    respond_to do |format|
      format.html { redirect_to root_path, alert: message, status: status }
      format.js { render "shared/error", locals: {message: message},
        status: status }
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:account_update) << :name
  end

  # def default_url_options
  #   if Rails.env.production?
  #     { host: 'underflow.riabit.ru' }
  #   else
  #     { host: 'localhost:3000' }
  #   end
  # end

  def set_default_page
    params[:page] ||= 1
  end
end
