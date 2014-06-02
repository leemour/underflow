class AnswersController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  before_action :set_answer, only: [:accept, :edit, :update, :destroy]
  before_action :check_permission, only: [:update, :destroy]
  before_action :set_question, only: [:new, :edit, :create, :update]
  before_action :set_user, only: [:voted, :by_user]
  before_action :check_accept_permission, only: [:accept]

  def voted
    @answers = Answer.joins(:votes).where(votes: {user_id: params[:user_id]})
  end

  def accept
    @answer.toggle(:accepted).save
    respond_to do |format|
      format.html { redirect_to @answer.question }
      format.js
    end
  end

  def by_user
    @answers = Answer.where(user_id: params[:user_id])
  end

  def new
  end

  def edit
  end

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = @question
    respond_to do |format|
      if @answer.save
        format.html { redirect_to @question, tr(:answer, 'created') }
        format.js
        format.json { render :create }
      else
        format.html { render :new }
        format.js
        format.json { render json: @answer.errors.full_messages,
          status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to @answer.question, tr(:answer, 'updated') }
        format.js
        format.json { render :update }
      else
        format.html { render :edit }
        format.js
        format.json { render json: {errors: @answer.errors.full_messages,
          id: @answer.id}, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @answer.destroy
    respond_to do |format|
      format.html { redirect_to @answer.question, tr(:answer, 'deleted') }
      format.js
    end
  end

  private

  def check_accept_permission
    render_error t('errors.denied') if @answer.question.user != current_user
    @question = @answer.question
    if @question.accepted_answer && @question.accepted_answer != @answer
      render_error t('errors.unprocessable'), :unprocessable_entity
    end
  end

  def check_permission
    render_error t('errors.denied') if @answer.user != current_user
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id,
      attachments_attributes: [:id, :file, :_destroy])
  end
end
