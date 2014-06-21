class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'], current_user)
    sign_in_and_redirect_with 'Facebook'
    # render json: request.env['omniauth.auth']
  end

  def twitter
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect_with 'Twitter'
    else
      session['devise.social_data'] = request.env['omniauth.auth']
      redirect_to enter_registration_email_path
    end
  end

  protected

  def sign_in_and_redirect_with(provider)
    sign_in_and_redirect @user, event: :authentication
      set_flash_message :notice, :success, kind: provider if is_navigational_format?
  end
end