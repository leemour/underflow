class SearchController < ApplicationController
  def search
    if params[:type]
      model = params[:type][0..-2].capitalize.constantize
      @results = model.search params[:q]
    else
      @results = ThinkingSphinx.search params[:q]
    end
  end
end
