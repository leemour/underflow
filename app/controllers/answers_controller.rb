class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]

  def create
    @answer = Answer.new(answer_params)

    if @answer.save
      redirect_to question_path(@answer.question),
        notice: t('model_created',
          model: t('activerecord.models.answer', count: 1))
    else
      redirect_to question_path(@answer.question),
        alert: @answer.errors.full_messages
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :question_id, :user_id)
  end
end
