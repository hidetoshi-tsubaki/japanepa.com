class LikeArticlesController < ApplicationController
  before_action :only_login_user!

  def create
    @article = Article.find(params[:id])
    current_user.like_article(@article)
    render 'like'
  end

  def destroy
    @article = Article.find(params[:id])
    current_user.remove_like_article(@article)
    render 'like'
  end
end
