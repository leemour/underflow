class QuestionsController < InheritedResources::Base
  include ApplicationHelper

  before_action :authenticate_user!, only: [:favor, :create, :edit, :update, :destroy]
  before_action :set_question, only: [:favor, :show, :edit, :update, :destroy]
  before_action :set_user, only: [:favorite, :voted, :by_user]
  before_action :check_permission, only: [:update, :destroy]
  before_action :set_default_page

  impressionist actions: [:show]

  def favorite
    @questions = Question.joins(:favorites).
      where(favorites: {user_id: params[:user_id]}).
      page(params[:page])
  end

  def favor
    @favored = @question.favor(current_user)
    respond_to do |format|
      format.html { redirect_to @question }
      format.json
    end
  end

  def tagged
    @tag = Tag.find(params[:tag_id])
    @questions = @tag.questions.page(params[:page])
  end

  def voted
    @questions = Question.joins(:votes).
      where(votes: {user_id: params[:user_id]}).
      page(params[:page])
  end

  def by_user
    @questions = Question.where(user_id: params[:user_id]).page(params[:page])
  end

  def index
    @questions = Question.includes(:tags).page(params[:page])
    @questions = @questions.send(params[:scope]) if params[:scope]
  end

  def show
    @answer = @question.answers.build
    @comment = @question.comments.build
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = current_user.questions.build(question_params)
    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, tr(:question, 'created') }
        format.js
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @question.update(question_params)
        @comment = @question.comments.build
        format.html { redirect_to @question, tr(:question, 'updated') }
        format.js
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @question.destroy
    respond_to do |format|
      format.html { redirect_to questions_path, tr(:question, 'deleted') }
      format.js
    end
  end

  private

  def set_question
    @question = Question.includes(answers: [:comments, :attachments, :user]).
      find(params[:id])
  end

  def set_comment
    @comment = @question.comments.build
  end

  def check_permission
    render_error t('errors.denied') if @question.user != current_user
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def question_params
    params[:question][:tag_list] ||= []
    params.require(:question).permit(:title, :body, tag_list: [],
      attachments_attributes: [:id, :file, :_destroy])
  end
end
