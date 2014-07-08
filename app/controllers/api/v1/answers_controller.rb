class Api::V1::AnswersController < Api::V1::BaseController
  belongs_to :question, parent_class: Question, optional: true
  actions :all, except: [:new, :edit]

  load_and_authorize_resource

  def index
    respond_with collection, meta: { timestamp: Answer.last_timestamp }
  end

  protected

  def create_resource(object)
    object.user = current_resource_owner
    super
  end

  def answer_params
    params.require(:answer).permit(:body, :question_id,
      attachments_attributes: [:id, :file, :_destroy])
  end
end