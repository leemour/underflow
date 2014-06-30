class Api::V1::UsersController < Api::V1::ApiController
  def me
    respond_with current_resource_owner.to_json(except: :admin)
  end

  def index
    @users = User.all
    respond_with @users.to_json(except: :admin)
  end
end