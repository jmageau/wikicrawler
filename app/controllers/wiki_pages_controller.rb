class WikiPagesController < ApplicationController

  def index
    @wiki_pages = WikiPage.all
  end

  def show
    @wiki_page = WikiPage.find(params[:id])
  end

end
