class ArticlesController < ApplicationController
  impressionist :actions => [:show]
  def index
    if params[:tag].present?
      @article = Article.tagged_with(params[:tag])
    else
      @articles = Article.all
    end
    @tags = Article.tags_on(:tags)
  end

  def show
    @article = Article.find(params[:id])
    @tags = @article.tags_on(:tags)
  end

end
