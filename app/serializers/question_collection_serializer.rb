class QuestionCollectionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :updated_at, :created_at, :short_title
  has_many :answers

  def short_title
    object.title.truncate(20)
  end
end