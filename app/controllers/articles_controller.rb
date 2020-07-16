class ArticlesController < ApplicationController
  before_action :only_login_user!
  before_action :get_unchecked_announce_count, :get_current_level, :get_not_done_reviews_count
  before_action :set_article_tags, only: [:index, :search, :tag_search]
  before_action :set_ranked_articles, only: [:show, :index, :search, :tag_search]
  impressionist :actions => [:show]

  def index
    @q = Article.with_attached_img.ransack(params[:q])
    @articles = @q.result(distinct: true).paginate(params[:page], 15)
  end

  def show
    if @article = Article.find_by_id(params[:id])
      @tags = @article.tags_on(:tags)
      @q = Article.with_attached_img.ransack(params[:q])
    else
      redirect_to articles_path
    end
  end

  def tag_search
    @articles = Article.with_attached_img.tagged_with(params[:tag]).sorted
    @q = Article.ransack(params[:q])
    render template: 'articles/index'
  end

  def search
    if params[:q] != nil
      params[:q]['title_or_lead_cont_any'] = params[:q]['title_or_lead_cont_any'].split(/[ ]/)
      @keywords = Article.with_attached_img.ransack(params[:q])
      @articles = @keywords.result.sorted
      @q = Article.ransack(params[:q])
    else
      @q = Article.ransack(params[:q])
      @articles = @q.result(distinct: true).sorted
    end
    render template: 'articles/index'
  end

  private

  def set_article_tags
    @tags = Article.all_tags
  end

  def set_ranked_articles
    @viewed_top_3 = Article.viewed_top_3
    @bookmarked_top_3 = Article.bookmarked_top_3
    @liked_top_3 = Article.liked_top_3
  end
end
