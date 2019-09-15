class ArticlesController < ApplicationController
  before_action :set_article_tags
  impressionist :actions => [:show]
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  private

    def set_article_tags
      @tags = Article.tags_on(:tags)
    end

end
