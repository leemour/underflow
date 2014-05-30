class VotesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]
  before_action :set_voteable, only: [:up, :down]

  def up
    @voteable.vote_up(current_user)
    respond_to do |format|
      format.html { redirect_to @question }
      format.js
    end
  end

  def down
    @voteable.vote_down(current_user)
    respond_to do |format|
      format.html { redirect_to @question }
      format.js
    end
  end

  protected

  def set_voteable
    parent ||= %w[question answer].find {|p| params.has_key? "#{p}_id"}
    @voteable = parent.classify.constantize.find(params["#{parent}_id"])
    @question = @voteable.is_a?(Question) ? @voteable : @voteable.question
  end
end