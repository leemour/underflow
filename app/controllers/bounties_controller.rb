class BountiesController < InheritedResources::Base
  include ApplicationHelper

  respond_to :html, :js
  belongs_to :question
  defaults singleton: true

  actions :create, :destroy

  before_action :authenticate_user!
  # before_action :set_question
  before_action :check_permissions

  def create
    create!(tr(:bounty, 'created', 'female')) { parent }
  end
  # def create
  #   @question.create_bounty(bounty_params)
  #   respond_to do |format|
  #     format.html { redirect_to @question, tr(:bounty, 'created', 'female') }
  #     format.js
  #   end
  # end

  def destroy
    destroy!(tr(:bounty, 'deleted', 'female')) { parent }
  end
  # def destroy
  #   @question.bounty.destroy
  #   respond_to do |format|
  #     format.html { redirect_to @question, tr(:bounty, 'deleted', 'female') }
  #     format.js
  #   end
  # end

  protected

  # def set_question
  #   @question = Question.find(params[:question_id])
  # end

  def check_permissions
    render_error t('errors.denied') if parent.user != current_user
  end

  def bounty_params
    params.require(:bounty).permit(:value)
  end
end