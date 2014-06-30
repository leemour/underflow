class Api::V1::ApiController < InheritedResources::Base
  doorkeeper_for :all

  respond_to :json
  layout false

  protected

  def current_resource_owner
    @current_resource_owner ||=
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end