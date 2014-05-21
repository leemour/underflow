class CommentsController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :check_permission, only: [:update, :destroy]
  before_action :set_commentable, only: [:new, :create, :destroy]

  def new
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.commentable = @commentable
    respond_to do |format|
      if @comment.save
        format.html do
          if @commentable.is_a? Question
            redirect_to @commentable, tr(:comment, 'created')
          elsif @commentable.is_a? Answer
            redirect_to @commentable.question, tr(:comment, 'created')
          end
        end
        format.js
      else
        format.html { render :new }
        format.js
      end
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html do
        if @commentable.is_a? Question
          redirect_to @commentable, tr(:comment, 'deleted')
        elsif @commentable.is_a? Answer
          redirect_to @commentable.question, tr(:comment, 'deleted')
        end
      end
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
  end

  def check_permission
    render_error t('errors.denied') if @comment.user != current_user
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end