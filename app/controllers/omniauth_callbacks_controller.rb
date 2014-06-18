class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'], current_user)
    sign_in_and_redirect @user, event: :authentication
    set_flash_message :notice, :success, kind: 'Facebook' if is_navigational_format?
    # render json: request.env['omniauth.auth']
  end

  def twitter
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message :notice, :success, kind: 'Twitter' if is_navigational_format?
    else
      session['devise.twitter_data'] = request.env['omniauth.auth']
      redirect_to enter_registration_email_path
    end
  end
end