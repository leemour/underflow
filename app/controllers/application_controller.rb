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

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  rescue_from CanCan::AccessDenied do |exception|
    render_error t('errors.denied')
  end

  protected

  def render_error(message, status=403)
    @message = message
    @status = status
    respond_to do |format|
      format.html { render "static/error", status: status }
      format.js { render "static/error", status: status }
      format.json { render json: {message: @message}, status: status }
    end
    return
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push :name, :email
    devise_parameter_sanitizer.for(:sign_in) << :login
    devise_parameter_sanitizer.for(:account_update) << :name
  end
end
