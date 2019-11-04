class ArticlesController < ApplicationController
  before_action :set_article_tags, only: [:index, :search, :tag_search]
  before_action :set_ranked_articles, only: [:index]
  impressionist :actions => [:show]

  def index
    @q = Article.ransack(params[:q])
    @articles = @q.result(distinct: true).sorted.page(params[:page])
  end

  def show
    @article = Article.find(params[:id])
    @tags = @article.tags_on(:tags)
  end

  def tag_search
    @articles = Article.tagged_with(params[:tag]).sorted
    @q = Article.ransack(params[:q]).page(params[:page])
    render template: 'articles/index'
  end

  def search
    if params[:q] != nil
      params[:q]['title_or_lead_cont_any'] = params[:q]['title_or_lead_cont_any'].split(/[ ]/)
      @keywords = Article.ransack(params[:q])
      @articles = @keywords.result.sorted.page(params[:page])
      @q = Article.ransack(params[:q])
    else
      @q = Article.ransack(params[:q])
      @articles = @q.result(distinct: true).sorted.page(params[:page])
    end
    render template: 'articles/index'
  end

  private

  def set_article_tags
    @tags = Article.tags_on(:tags)
  end

  def set_ranked_articles
    @viewed_top_3 = Article.viewed_top_3
    @bookmarked_top_3 = Article.bookmarked_top_3
    @liked_top_3 = Article.liked_top_3
  end
end
