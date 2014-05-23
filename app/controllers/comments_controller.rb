class CommentsController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :check_permission, only: [:update, :destroy]
  before_action :set_commentable, only: [:new, :edit, :create, :update, :destroy]

  def new
    @comment = Comment.new
  end

  def edit
  end

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.commentable = @commentable
    respond_to do |format|
      if @comment.save
        format.html { redirect_to @question, tr(:comment, 'created') }
        format.js
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @question, tr(:comment, 'updated') }
        format.js
      else
        format.html { render :edit }
        format.js
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to @question, tr(:comment, 'deleted') }
      format.js
    end
  end

  protected

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_commentable
    parent ||= %w[question answer].find {|p| params.has_key? "#{p}_id"}
    @commentable = parent.classify.constantize.find(params["#{parent}_id"])
    @question = @commentable.is_a?(Question) ? @commentable : @commentable.question
  end

  def check_permission
    render_error t('errors.denied') if @comment.user != current_user
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end