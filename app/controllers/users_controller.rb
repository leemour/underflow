class UsersController < InheritedResources::Base
  include ApplicationHelper

  respond_to :html
  actions :index, :show, :edit, :update
  custom_actions resource: :reset_password

  before_action :authenticate_user!, only: [:edit, :update, :reset_password]
  before_action :check_permission, only: [:edit, :update, :reset_password]

  def update
    update! tr(:profile, 'updated') { resource }
  end

  def reset_password
    resource.send_reset_password_instructions
    redirect_to root_path, notice: t('devise.passwords.send_instructions')
  end

  protected

  def collection
    @users ||= end_of_association_chain.page(params[:page])
  end

  def check_permission
    render_error t('errors.denied') if resource != current_user
  end

  def user_params
    params.require(:user).permit(:avatar, profile_attributes: [:id, :real_name,
      :website, :location, :birthday, :about, :_destroy])
  end
end