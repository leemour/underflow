class CommentsController < InheritedResources::Base
  include ApplicationHelper

  respond_to :html, :js
  belongs_to :question, :answer, polymorphic: true

  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  before_action :set_question, only: [:new, :edit, :create, :update, :destroy]

  load_and_authorize_resource

  def create
    create!(tr(:comment, 'created')) { @question }
  end

  def update
    update!(tr(:comment, 'updated')) { @question }
  end

  def destroy
    destroy!(tr(:comment, 'deleted')) { @question }
  end

  protected

  def create_resource(object)
    object.user = current_user
    super
  end

  def set_question
    @question = parent.is_a?(Question) ? parent : parent.question
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end