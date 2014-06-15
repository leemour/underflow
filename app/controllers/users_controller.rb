class UsersController < InheritedResources::Base
  include ApplicationHelper

  respond_to :html
  actions :index, :show, :edit, :update

  def update
    update! tr(:profile, 'updated')
  end

  protected

  def collection
    @users ||= end_of_association_chain.page(params[:page])
  end

  def user_params
    params.require(:user).permit(:avatar, profile_attributes: [:id, :real_name,
      :website, :location, :birthday, :about, :_destroy])
  end
end