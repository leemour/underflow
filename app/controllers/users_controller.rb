class UsersController < InheritedResources::Base
  include ApplicationHelper

  respond_to :html
  actions :index, :show, :edit, :update
  # before_action :set_user, only: [:show, :edit, :update]

  # def index
  #   @users = User.page(params[:page])
  # end

  # def show
  # end

  # def edit
  # end


  def update
    update! tr(:profile, 'updated')
  end
  # def update
  #   if @user.update(user_params)
  #     redirect_to @user, tr(:profile, 'updated')
  #   else
  #     render :edit
  #   end
  # end

  protected

  def collection
    @users ||= end_of_association_chain.page(params[:page])
  end

  # def set_user
  #   @user = User.find(params[:id])
  # end

  def user_params
    params.require(:user).permit(:avatar, profile_attributes: [:id, :real_name,
      :website, :location, :birthday, :about, :_destroy])
  end
end