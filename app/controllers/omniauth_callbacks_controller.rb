class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message :notice, :success, kind: 'Facebook' if is_navigational_format?
    else
      session['devsies.facebook_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_path
    end
    # render json: request.env['omniauth.auth']
  end
end