class Api::V1::AnswersController < Api::V1::BaseController
  belongs_to :question, parent_class: Question, optional: true

  def index
    respond_with collection, meta: { timestamp: Answer.last_timestamp }
  end

  protected

  def answer_params
    params.require(:answer).permit(:body, :question_id,
      attachments_attributes: [:id, :file, :_destroy])
  end
end