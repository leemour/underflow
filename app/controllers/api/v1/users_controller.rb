class Api::V1::UsersController < Api::V1::ApiController
  defaults resource_class: User

  def me
    respond_with current_resource_owner.to_json(except: :admin)
  end

  def index
    respond_with collection.to_json(except: :admin, include: :profile)
  end

  protected

  def collection
    @users ||= end_of_association_chain.includes(:profile)
  end
end