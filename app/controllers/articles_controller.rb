class ArticlesController < ApplicationController
  before_action :authenticate_admin!, only: [:new,:create,:edit,:update,:delete]
  impressionist :actions=> [:show]
  def index
    @articles = Article.order('created_at DESC').page(params[:page]).per(10)
  end
  
  def show
    @article = Article.find(params[:id])
  end

  def new
     @article = Article.new
  end

  def create 
    @article = Article.new(article_params)
    if @article.save
      flash.now[:notice] = 'article was saved successfully'
      redirect_to articles_index_path
      else  
      flash.now[:notice] = 'failed to save article .Try again'
      render 'new'
    end
  end

  def edit
     @article = Article.find(params[:id])
    
  end

  def update
    @article = Article.new(article_params)
    if @article.update
      flash.now[:notice]= 'article was updated successfully'
      redirect_to articles_index_path
    else
      flash.now[:notice] ='failed to update article...'
      render 'edit'
    end
  end

  def delete 
    if Article.find(params[:id]).destroy
      puts "delete Article successfully"
      @articles = Article.all
      redirect_to articles_index_path
    else
      flash.now[:notice]="failed to delete Article......"
      render 'edit'
    end
    
  end

  def image_upload
    image_uploader = Article::ImageUploader.new(params[:upload_image])
    if image_uploader.upload_image
      object = image_uploader.get_bucket.object(image_uploader.get_key_name)
      url = object.public_url.sub!(/.ap/,"-ap")
      render( json: { url: URI.parse(url) } )
    else
      head 400
    end
  end

  def delete_image
    p params[:image_url]
    image_delete = Article::DeleteImage.new(params[:image_url])
    if image_delete.delete
      puts "deleted the image successfully"
    else
      head 400
    end
  end


  private
  def article_params
    params.require(:article).permit(:title,:lead,:image,:img_cache,:remove_image,:contents,)
  end
end
