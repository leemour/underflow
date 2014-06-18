class RegistrationsController < Devise::RegistrationsController
  def enter_email
    @user = User.new
    render 'devise/registrations/enter_email'
  end

  def sign_up_with_email
    data = session['devise.twitter_data']
    @user = User.build_from_email_and_session(user_params, data)
    if @user.save
      @user.authorizations.create(provider: data.provider, uid: data.uid.to_s)
      if @user.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up_user @user
        respond_with @user, location: after_sign_up_path_for(@user)
      else
        set_flash_message :notice, :"signed_up_but_#{@user.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with @user, location: after_inactive_sign_up_path_for(@user)
      end
    else
      render 'devise/registrations/enter_email'
    end
  end

  protected

  def user_params
    params.require(:user).permit(:email)
  end
end