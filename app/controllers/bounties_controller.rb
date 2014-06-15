class BountiesController < InheritedResources::Base
  include ApplicationHelper

  respond_to :html, :js
  belongs_to :question
  defaults singleton: true

  actions :create, :destroy

  before_action :authenticate_user!
  before_action :check_permissions

  def create
    create!(tr(:bounty, 'created', 'female')) { parent }
  end

  def destroy
    destroy!(tr(:bounty, 'deleted', 'female')) { parent }
  end

  protected

  def check_permissions
    render_error t('errors.denied') if parent.user != current_user
  end

  def bounty_params
    params.require(:bounty).permit(:value)
  end
end