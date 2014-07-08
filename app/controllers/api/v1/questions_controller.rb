class Api::V1::QuestionsController < Api::V1::BaseController
  actions :all, except: [:new, :edit]

  load_and_authorize_resource except: [:index]

  def index
    respond_with collection, each_serializer: QuestionCollectionSerializer,
      meta: { timestamp: Question.last_timestamp }
  end

  protected

  def create_resource(object)
    object.user = current_resource_owner
    super
  end

  def question_params
    params[:question][:tag_list] ||= [] if params[:question]
    params.require(:question).permit(:title, :body, tag_list: [],
      attachments_attributes: [:id, :file, :_destroy])
  end
end