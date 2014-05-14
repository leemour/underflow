class QuestionsController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = current_user.questions.build(question_params)
    respond_to do |format|
      if @question.save
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
        format.html { redirect_to questions_path }
        format.js { render nothing: true, status: :forbidden }
      elsif @question.update(question_params)
        format.html { redirect_to @question, tr(:question, 'updated') }
        format.js
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    if @question.user == current_user
      @question.destroy
      redirect_to questions_path, tr(:question, 'deleted')
    else
      redirect_to questions_path
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :user_id, :status)
  end
end
