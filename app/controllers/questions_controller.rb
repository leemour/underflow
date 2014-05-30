class QuestionsController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :check_permission, only: [:update, :destroy]

  def by_user
    @questions = Question.where(user_id: params[:user_id])
  end

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @comment = @question.comments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question, tr(:question, 'created')
    else
      render :new
    end
  end

  def update
    respond_to do |format|
      if @question.update(question_params)
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
    params[:question][:tag_list] ||= []
    params.require(:question).permit(:title, :body, tag_list: [],
      attachments_attributes: [:id, :file, :_destroy])
  end
end
