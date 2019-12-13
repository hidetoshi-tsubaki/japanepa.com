class Admin::ArticlesController < ApplicationController
  before_action :authenticate_admin!, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :set_article_tags, only: [ :index, :search, :tag_search ]
  before_action :set_available_tags_to_gon, only: [ :new, :edit, :confirm ]

  def index
    @q = Article.ransack(params[:q])
    @articles = @q.result(distinct: true).page(params[:page])
  end

  def show
    @article = Article.find(params[:id])
    @tags = @article.tags_on(:tags)
  end

  def new
    @article = Article.new
  end

  def comfirm
    @article = Article.new(article_params)
    return if @article.valid?
    render :new
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
      flash.now[:notice] = 'article was updated successfully'
      redirect_to admin_articles_path
    else
      flash.now[:notice] = 'failed to update article...'
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id]).destroy
  end

  def bookmark_articles
    Article.includes(:bookmarks).references.(:bookmarks).where("bookmark.id", current_user.id).sort_and_paginate(10)
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
    if params[:q]['title_or_lead_cont_any'] != nil
      params[:q]['title_or_lead_cont_any'] = params[:q]['title_or_lead_cont_any'].split(/[ ]/)
      @keywords = Article.ransack(params[:q])
      @articles = @keywords.result.page(params[:page])
      @q = Article.ransack(params[:q])
    else
      @q = Article.ransack(params[:q])
      @articles = @q.result(distinct: true).page(params[:page])
    end
    render template: 'admin/articles/index'
  end

  def tag_search
    @articles = Article.tagged_with(params[:tag]).page(params[:page])
    @q = Article.ransack(params[:q])
    render template: 'admin/articles/index'
  end

  private

  def article_params
    params.require(:article).permit(:title, :lead, :tag_list, :img, :img_cache, :remove_img, :contents)
  end

  def set_available_tags_to_gon
    gon.available_tags = Article.tags_on(:tags).pluck(:name)
  end

  def set_article_tags
    @tags = Article.all_tags
  end

  def is_pagination?(params)
    if params[:q]['title_or_lead_cont_any'].kind_of?(Array)
      params[:q]['title_or_lead_cont_any'] = params[:q]['title_or_lead_cont_any'].join(" ")
    end
  end

end
