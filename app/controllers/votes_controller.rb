class VotesController < InheritedResources::Base
  before_action :authenticate_user!, only: [:up, :down]
  before_action :set_question

  belongs_to :question, :answer, polymorphic: true

  # load_and_authorize_resource

  def up
    @vote = parent.vote_up(current_user)
    respond_to do |format|
      format.html { redirect_to @question }
      format.json { render :up_and_down }
    end
  end

  def down
    @vote = parent.vote_down(current_user)
    respond_to do |format|
      format.html { redirect_to @question }
      format.json { render :up_and_down }
    end
  end

  protected

  def set_question
    @question = parent.is_a?(Question) ? parent : parent.question
  end
end