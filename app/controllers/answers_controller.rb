class AnswersController < InheritedResources::Base
  include ApplicationHelper

  respond_to :html, :js
  belongs_to :question

  actions :all, :except => [ :new ]
  custom_actions resource: :accept

  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  # before_action :set_answer, only: [:accept, :edit, :update, :destroy]
  before_action :set_answer, only: [:accept]
  before_action :check_permission, only: [:update, :destroy]
  # before_action :set_question, only: [:accept, :new, :edit, :create, :update, :destroy]
  before_action :set_user, only: [:voted, :by_user]
  before_action :check_accept_permission, only: [:accept]

  def voted
    @answers = Answer.joins(:votes).
      where(votes: {user_id: params[:user_id]}).
      page(params[:page])
  end

  def accept
    @answer.toggle_accepted_from @question
    respond_to do |format|
      format.html { redirect_to @question }
      format.js
    end
  end

  def by_user
    @answers = Answer.where(user_id: params[:user_id]).page(params[:page])
  end

  def create
    create!(tr(:answer, 'created')) { parent_url }
  end
  # def create
  #   @answer = current_user.answers.build(answer_params)
  #   @answer.question = @question
  #   respond_to do |format|
  #     if @answer.save
  #       format.html { redirect_to @question, tr(:answer, 'created') }
  #       format.js
  #     else
  #       format.html { render :new }
  #       format.js
  #     end
  #   end
  # end

  def update
    update!(tr(:answer, 'updated')) { parent_url }
  end
  # def update
  #   respond_to do |format|
  #     if @answer.update(answer_params)
  #       format.html { redirect_to @answer.question, tr(:answer, 'updated') }
  #       format.js
  #       format.json { render :update }
  #     else
  #       format.html { render :edit }
  #       format.js
  #       format.json { render json: {errors: @answer.errors.full_messages,
  #         id: @answer.id}, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def destroy
    destroy!(tr(:answer, 'deleted')) { parent_url }
  end
  # def destroy
  #   @answer.destroy
  #   respond_to do |format|
  #     format.html { redirect_to @answer.question, tr(:answer, 'deleted') }
  #     format.js
  #   end
  # end

  protected

  def create_resource(object)
    object.user = current_user
    super
  end

  def check_accept_permission
    render_error t('errors.denied') if @answer.question.user != current_user
    @question = @answer.question
    if @question.accepted_answer && @question.accepted_answer != @answer
      render_error t('errors.unprocessable'), :unprocessable_entity
    end
  end

  def check_permission
    render_error t('errors.denied') if resource.user != current_user
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  # def set_question
  #   @question = Question.find_by_id(params[:question_id])
  # end

  def set_user
    @user = User.find(params[:user_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id,
      attachments_attributes: [:id, :file, :_destroy])
  end
end
