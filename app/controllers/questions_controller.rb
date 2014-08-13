class QuestionsController < InheritedResources::Base
  include ApplicationHelper

  respond_to :html, :js, :json

  before_action :authenticate_user!, only: [:favor, :create, :edit, :update,
    :destroy, :new, :subscribe, :unsubscribe]
  before_action :set_user, only: [:favorited, :voted, :by_user]
  before_action :set_tags, only: [:new, :edit]

  impressionist actions: [:show]

  load_and_authorize_resource except: [:index, :new]

  def subscribe
    resource.subscribe(current_user)
    respond_to do |format|
      format.html { redirect_to resource, tr(:question, 'subscribed') }
      format.js
    end
  end

  def unsubscribe
    resource.unsubscribe(current_user)
    respond_to do |format|
      format.html { redirect_to resource, tr(:question, 'unsubscribed') }
      format.js
    end
  end

  def favor
    @favored = resource.favor(current_user)
    respond_to do |format|
      format.html { redirect_to resource }
      format.json
    end
  end

  def favorited
    @questions = Question.favorited(params[:user_id]).page(params[:page])
  end

  def tagged
    @tag = Tag.find(params[:tag_id])
    @questions = @tag.questions.page(params[:page])
  end

  def voted
    @questions = Question.voted_by(params[:user_id]).page(params[:page])
  end

  def by_user
    @questions = Question.where(user_id: params[:user_id]).page(params[:page])
  end

  def show
    @question ||= end_of_association_chain.includes(
      answers: [:comments, :attachments, :user]).find(params[:id])
  end

  def create
    create!(tr(:question, 'created'))
  end


  def update
    update!(tr(:question, 'updated'))
  end

  def destroy
    destroy!(tr(:question, 'deleted'))
  end

  protected

  def create_resource(object)
    object.user = current_user
    super
  end

  def collection
    @questions ||= params[:scope] ?
      end_of_association_chain.includes(:tags, :user).send(params[:scope]).page(params[:page]) :
      end_of_association_chain.includes(:tags, :user).page(params[:page])
  end

  def resource
    @question ||= end_of_association_chain.includes(
      answers: [:comments, :attachments, :user]).find(params[:id])
  end

  def set_tags
    gon.tag_names = Tag.name_list
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def question_params
    params[:question][:tag_list] ||= [] if params[:question]
    params.require(:question).permit(:title, :body, tag_list: [],
      attachments_attributes: [:id, :file, :_destroy])
  end
end
