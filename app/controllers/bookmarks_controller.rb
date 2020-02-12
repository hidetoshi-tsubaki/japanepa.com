class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def index
    @articles = Article.bookmarks
  end
  
  def create
    @article = Article.find(params[:id])
    current_user.bookmark(@article) unless current_user.already_bookmark?(@article)
    render "bookmark"
  end

  def destroy
    @article = Article.find(params[:id])
    current_user.remove_bookmark(@article) if current_user.already_bookmark?(@article)
    render "bookmark"
  end
end
