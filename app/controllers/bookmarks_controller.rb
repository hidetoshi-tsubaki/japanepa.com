class BookmarksController < ApplicationController

  def bookmark
    @article = Article.find(params[:id])
    current_user.bookmark(@article)
  end

  def remove_bookmark
    @article = Articl.find(params[:id])
    current_user.remove_bookmark(@article)
  end
end
