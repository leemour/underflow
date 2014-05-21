class QuestionsController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :check_permission, only: [:update, :destroy]
  # before_action :set_comment, only: [:show, :update]

  def by_user
    @questions = Question.where(user_id: params[:user_id])
  end

  def index
    @questions = Question.all
  end

  def show
    @question.attachments.build
    @answer = @question.answers.build
    @comment = @question.comments.build
    @question.answers.each {|a| a.attachments.build }
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = current_user.questions.build(question_params)
    respond_to do |format|
      if @question.save
        @comment = @question.comments.build
        format.html { redirect_to @question, tr(:question, 'created') }
        format.js
      else
        format.html { render action: "new" }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @question.user != current_user
        render_error t('errors.denied')
      elsif @question.update(question_params)
        @comment = @question.comments.build
        format.html { redirect_to @question, tr(:question, 'updated') }
        format.js
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, tr(:question, 'deleted')
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def set_comment
    @comment = @question.comments.build
  end

  def check_permission
    render_error t('errors.denied') if @question.user != current_user
  end

  def question_params
    params.require(:question).permit(:title, :body,
      attachments_attributes: [:id, :file, :_destroy])
  end
end
