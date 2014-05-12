class AnswersController < ApplicationController
  before_action :set_answer, only: [:edit, :update, :destroy]
  before_action :set_question, only: [:new, :edit, :create, :update]
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]

  def new
  end

  def edit
  end

  def create
    @answer = current_user.answers.build(answer_params)
    @answer.question = @question
    if @answer.save
      redirect_to question_path(@question),
        notice: t('model_created',
          model: t('activerecord.models.answer', count: 1))
    else
      render action: 'new'
    end
  end

  def update
    respond_to do |format|
      if @answer.update(answer_params)
        format.html { redirect_to @answer.question,
          notice: t('model_updated',
            model: t('activerecord.models.answer', count: 1)) }
        format.json { render :show, status: :ok, location: @answer }
      else
        format.html { render :edit }
        format.json { render json: @answer.errors,
          status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @answer.destroy if @answer.user == current_user
    respond_to do |format|
      format.html { redirect_to question_path(@answer.question),
        notice: t('model_deleted',
          model: t('activerecord.models.answer', count: 1)) }
      format.json { head :no_content}
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
