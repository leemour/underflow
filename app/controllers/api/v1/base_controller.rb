class Api::V1::BaseController < InheritedResources::Base
  doorkeeper_for :all

  respond_to :json
  layout false

  protected

  def current_resource_owner
    @current_resource_owner ||=
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_ability
    @current_ability ||= Ability.new(current_resource_owner)
  end
end