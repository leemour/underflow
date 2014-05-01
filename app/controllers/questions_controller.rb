class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
  end

  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_to(@question, :notice => t('model_created', model: t('question'))) }
        format.json { render :json => @question }
      else
        format.html { render :action => "new" }
        format.json { render :json => @question.errors, :status => :unprocessable_entity }
      end
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, :user_id, :status)
  end
end
