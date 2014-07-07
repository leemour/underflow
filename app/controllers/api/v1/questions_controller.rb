class Api::V1::QuestionsController < Api::V1::BaseController

  def index
    respond_with collection, each_serializer: QuestionCollectionSerializer,
      meta: { timestamp: Question.last_timestamp }
  end
end