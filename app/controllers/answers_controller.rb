class AnswersController < ApplicationController
  include ApplicationHelper

  before_action :set_answer, only: [:edit, :update, :destroy]
  before_action :set_question, only: [:new, :edit, :create, :update]
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]

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
      else
        format.html { render action: 'new' }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @answer.user != current_user
        format.html { redirect_to @question }
        format.js { render nothing: true, status: :forbidden }
      elsif @answer.update(answer_params)
        format.html { redirect_to @answer.question, tr(:answer, 'updated') }
        format.js
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    respond_to do |format|
      if @answer.user == current_user
        @answer.destroy
        format.html { redirect_to @answer.question, tr(:answer, 'deleted') }
        format.js
      else
        format.html { redirect_to @answer.question }
        format.js { render nothing: true, status: :forbidden }
      end
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id, :user_id)
  end
end
