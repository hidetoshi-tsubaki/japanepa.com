class LikesArticlesController < ApplicationController

  def like
    @article = Article.find(params[:id])
    current_user.like_article(@article)
  end

  def remove_like
    @article = Articl.find(params[:id])
    current_user.remove_like(@article)
  end
end
