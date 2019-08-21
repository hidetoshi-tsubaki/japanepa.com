class LikesArticlesController < ApplicationController
  def like_article
    @article = Article.find(params[:id])
    current_user.like_article(@article)
  end

  def remove_like_article
    @article = Article.find(params[:id])
    current_user.remove_like(@article)
  end
end
