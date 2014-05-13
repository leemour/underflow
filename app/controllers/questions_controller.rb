class QuestionsController < ApplicationController
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
        format.html { redirect_to @question,
          notice: t('model.created',
            model: t('activerecord.models.question', count: 1)) }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render action: "new" }
        format.json { render json: @question.errors,
          status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @question.user != current_user
        format.html { redirect_to questions_path }
        format.json { head :no_content}
      elsif @question.update(question_params)
        format.html { redirect_to @question,
          notice: t('model.updated',
            model: t('activerecord.models.question', count: 1)) }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors,
          status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @question.destroy if @question.user == current_user
    respond_to do |format|
      format.html { redirect_to questions_path,
        notice: t('model.deleted',
          model: t('activerecord.models.question', count: 1)) }
      format.json { head :no_content}
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
