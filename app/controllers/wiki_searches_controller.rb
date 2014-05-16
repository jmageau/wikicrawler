class WikiSearchesController < ApplicationController
  include WikiSearchesHelper

  def index
    @wiki_searches = WikiSearch.all
  end

  def new
    @wiki_search = WikiSearch.new
  end

  def create
    @wiki_search = WikiSearch.new(search_params)
    @wiki_search.steps = get_steps(@wiki_search.start_title, @wiki_search.goal_title).to_s
    @wiki_search.save
    redirect_to wiki_searches_path
  end

  def destroy
    @wiki_search = WikiSearch.find(params[:id])
    @wiki_search.destroy
    redirect_to wiki_searches_path
  end

end
