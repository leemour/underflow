class AnswersController < InheritedResources::Base
  include ApplicationHelper

  respond_to :html, :js
  belongs_to :question, optional: true
  actions :all, except: :new
  custom_actions resource: :accept, collection: :voted

  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  # before_action :check_permission, only: [:update, :destroy]
  before_action :set_user, only: [:voted, :by_user]
  # before_action :check_accept_permission, only: [:accept]

  load_and_authorize_resource except: [:by_user, :voted]

  def accept
    resource.toggle_accepted_from parent
    respond_to do |format|
      format.html { redirect_to parent }
      format.js
    end
  end

  def voted
    @answers = Answer.voted_by(params[:user_id])
  end

  def by_user
    @answers = Answer.where(user_id: params[:user_id]).
      includes(:user, :question).page(params[:page])
  end

  def create
    create!(tr(:answer, 'created')) { parent_url }
  end

  def update
    update!(tr(:answer, 'updated')) { parent_url }
  end

  def destroy
    destroy!(tr(:answer, 'deleted')) { parent_url }
  end

  protected

  def create_resource(object)
    object.user = current_user
    super
  end

  # def check_accept_permission
  #   render_error t('errors.denied') if parent.user != current_user
  #   if parent.accepted_answer && parent.accepted_answer != resource
  #     render_error t('errors.unprocessable'), :unprocessable_entity
  #   end
  # end

  # def check_permission
  #   render_error t('errors.denied') if resource.user != current_user
  # end

  def set_user
    @user = User.find(params[:user_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id,
      attachments_attributes: [:id, :file, :_destroy])
  end
end
