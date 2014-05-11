class AnswersController < ApplicationController
  before_action :set_answer, only: [:edit, :update, :destroy]
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]

  def edit
  end

  def create
    @answer = current_user.answers.build(answer_params)
    if @answer.save
      redirect_to question_path(@answer.question),
        notice: t('model_created',
          model: t('activerecord.models.answer', count: 1))
    else
      redirect_to question_path(@answer.question),
        alert: @answer.errors.full_messages
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
    @answer.destroy
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

  def answer_params
    params.require(:answer).permit(:body, :question_id, :user_id)
  end
end
