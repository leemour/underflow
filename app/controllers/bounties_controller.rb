class BountiesController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_user!
  before_action :set_question
  before_action :check_permissions

  def create
    @question.create_bounty(bounty_params)
    respond_to do |format|
      format.html { redirect_to @question, tr(:bounty, 'created', 'female') }
      format.js
    end
  end

  def destroy
    @question.bounty.destroy
    respond_to do |format|
      format.html { redirect_to @question, tr(:bounty, 'deleted', 'female') }
      format.js
    end
  end

  protected

  def set_question
    @question = Question.find(params[:question_id])
  end

  def check_permissions
    render_error t('errors.denied') if @question.user != current_user
  end

  def bounty_params
    params.require(:bounty).permit(:value)
  end
end