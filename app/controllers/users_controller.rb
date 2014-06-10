class UsersController < ApplicationController
  include ApplicationHelper

  before_action :set_user, only: [:show, :edit, :update]

  def index
    @users = User.page(params[:page])
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, tr(:profile, 'updated')
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:avatar, profile_attributes: [:id, :real_name,
      :website, :location, :birthday, :about, :_destroy])
  end
end