class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def bookmark
    @article = Article.find(params[:id])
    current_user.bookmark(@article)
  end

  def remove_bookmark
    @article = Article.find(params[:id])
    current_user.remove_bookmark(@article)
    render 'bookmark'
  end
end
