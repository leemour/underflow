class RegistrationsController < Devise::RegistrationsController
  before_action :set_user_and_check_email, only: :sign_up_with_email


  def enter_email
    @user = User.new
    render 'devise/registrations/enter_email'
  end

  def sign_up_with_email
    if @user.save
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

  def merge_accounts
    @user = User.find_by_email(params[:user][:email])
    if @user.valid_password?(params[:user][:password])
      @user.create_authorization(session['devise.social_data'])
      flash[:notice] = t('user.accounts_merged',
        provider: session['devise.social_data'].provider.capitalize)
      sign_in @user
      redirect_to root_path
    else
      @user.errors.add(:password, t('common.incorrect'))
      render 'devise/registrations/merge_accounts'
    end
  end

  protected

  def set_user_and_check_email
    data = session['devise.social_data']
    @user = User.build_from_email_and_session(user_params, data)
    if User.find_by_email(@user.email)
      render('devise/registrations/merge_accounts') && return
    end
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end