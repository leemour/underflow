class Api::V1::QuestionsController < Api::V1::BaseController

  # def show
  #   respond_with resource
  # end

  def index
    respond_with collection, each_serializer: QuestionIndexSerializer,
      meta: { timestamp: Question.last_timestamp }
  end
end