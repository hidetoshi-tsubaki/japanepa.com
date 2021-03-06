class Admin::ArticlesController < ApplicationController
  before_action :authenticate_admin!, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :set_article_tags, only: [:index, :search, :tag_search]
  before_action :set_available_tags_to_gon, only: [:new, :edit, :confirm]

  def index
    @q = Article.ransack(params[:q])
    @articles = @q.result(distinct: true).paginate(params[:page], 15)
  end

  def show
    @article = Article.find(params[:id])
    @tags = @article.tags_on(:tags)
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      flash.now[:notice] = 'article was saved successfully'
      redirect_to admin_articles_path
    else
      flash.now[:notice] = 'failed to save article .Try again'
      render 'new'
    end
  end

  def edit
    @article = Article.find(params[:id])
    gon.article_tags = @article.tag_list
  end

  def update
    @article = Article.find(params[:id])
    @article.update(article_params)
    if @article.save
      @article.img.purge if article_params[:delete_img].present?
      flash.now[:notice] = 'article was updated successfully'
      redirect_to admin_articles_path
    else
      flash.now[:notice] = 'failed to update article...'
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy
    respond_to do |format|
      format.html { redirect_to admin_articles_path }
      format.js { render :action => "destroy" }
    end
  end

  def bookmark_articles
    Article.
      includes(:bookmarks).
      references.call(:bookmarks).
      where("bookmark.id", current_user.id).
      paginate(params[15]).sorted
  end

  def upload_image
    image_uploader = Article::ImageUploader.new(params[:upload_image])
    if image_uploader.upload_image
      object = image_uploader.get_bucket.object(image_uploader.get_key_name)
      url = object.public_url.sub!(/.ap/, "-ap")
      render json: { url: URI.parse(url) }
    else
      head 400
    end
  end

  def delete_image
    image_delete = Article::DeleteImage.new(params[:image_url])
    if image_delete.delete
      puts "deleted the image successfully"
    else
      head 400
    end
  end

  def search
    is_pagination?(params)
    if !params[:q]['title_or_lead_cont_any'].nil?
      params[:q]['title_or_lead_cont_any'] = params[:q]['title_or_lead_cont_any'].split(/[ ]/)
      @keywords = Article.ransack(params[:q])
      @articles = @keywords.result.paginate(params[:page], 15)
      @q = Article.ransack(params[:q])
    else
      @q = Article.ransack(params[:q])
      @articles = @q.result(distinct: true).paginate(params[:page], 15)
    end
    render template: 'admin/articles/index'
  end

  def tag_search
    @articles = Article.tagged_with(params[:tag]).paginate(params[:page], 15)
    @q = Article.ransack(params[:q])
    render template: 'admin/articles/index'
  end

  private

  def article_params
    params.require(:article).permit(:title, :lead, :tag_list, :img, :delete_img, :contents, :status)
  end

  def set_available_tags_to_gon
    gon.available_tags = Article.tags_on(:tags).pluck(:name)
  end

  def set_article_tags
    @tags = Article.all_tags
  end

  def is_pagination?(params)
    if params[:q]['title_or_lead_cont_any'].is_a?(Array)
      params[:q]['title_or_lead_cont_any'] = params[:q]['title_or_lead_cont_any'].join(" ")
    end
  end
end
