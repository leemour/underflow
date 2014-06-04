class BountiesController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_user!
  before_action :check_permissions

  def start
    @question.create_bounty(bounty_params)
    respond_to do |format|
      format.html { redirect_to @question, tr(:bounty, 'created', 'female') }
    end
  end

  def award
  end

  def stop
    @question.bounty.destroy
    respond_to do |format|
      format.html { redirect_to @question, tr(:bounty, 'deleted', 'female') }
    end
  end

  protected

  def check_permissions
    @question = Question.find(params[:id])
    render_error t('errors.denied') if @question.user != current_user
  end

  def bounty_params
    params.require(:bounty).permit(:value)
  end
end