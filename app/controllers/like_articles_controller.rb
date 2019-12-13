class LikeArticlesController < ApplicationController
  before_action :authenticate_user!

  def create
    @article = Article.find(params[:id])
    current_user.like_article(@article)
    render 'like'
  end

  def destroy
    @article = Article.find(params[:id].to_i)
    current_user.remove_like_article(@article)
    render 'like'
  end
end
