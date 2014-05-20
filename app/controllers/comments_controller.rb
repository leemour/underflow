class CommentsController < ApplicationController
  include ApplicationHelper

  before_action :set_parent, only: [:new, :create]

  def new
    @comment = Comment.new
  end

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.commentable = @commentable
    if @comment.save
      if @commentable.is_a? Question
        redirect_to @commentable, tr(:comment, 'created')
      elsif @commentable.is_a? Answer
        redirect_to @commentable.question, tr(:comment, 'created')
      end
    else
      render :new
    end
  end

  protected

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_parent
    parent ||= %w[question answer].find {|p| params.has_key? "#{p}_id"}
    @commentable = parent.classify.constantize.find(params["#{parent}_id"])
  end
end