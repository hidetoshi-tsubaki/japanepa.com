class LikesArticlesController < ApplicationController
  before_action :authenticate_user!

  def like
    @article = Article.find(params[:id])
    current_user.like_article(@article)
  end

  def remove
    @article = Article.find(params[:id])
    current_user.remove_like_article(@article)
    render 'like'
  end
end
