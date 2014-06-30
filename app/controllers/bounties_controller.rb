class BountiesController < InheritedResources::Base
  include ApplicationHelper

  respond_to :html, :js
  belongs_to :question
  defaults singleton: true
  actions :create, :destroy

  before_action :authenticate_user!
  before_action :check_accepted_answer
  before_action :check_existing_bounty, only: :create
  # before_action :check_permissions

  load_resource :question
  load_and_authorize_resource through: :question

  def create
    create!(tr(:bounty, 'created', 'female')) { parent }
  end

  def destroy
    destroy!(tr(:bounty, 'deleted', 'female')) { parent }
  end

  protected

  def check_existing_bounty
    render_error t('errors.bounty_already_exists') if parent.bounty
  end

  def check_accepted_answer
    render_error t('errors.answer_already_accepted') if parent.accepted_answer
  end

  # def check_permissions
  #   render_error t('errors.denied') if parent.user != current_user
  # end

  def bounty_params
    params.require(:bounty).permit(:value)
  end
end