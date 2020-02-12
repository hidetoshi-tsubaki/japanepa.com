
class Admin::InformationController < ApplicationController

  def index
    @q = Information.ransack(params[:q])
    @information = @q.result(distinct: true).page(params[:page])
  end

  def show
    @info = Information.find(params[:id])
  end

  def new
    @info = Information.new
  end

  def create
    @info = Information.new(info_params)
    if @info.save
      redirect_to admin_information_index_path(@info)
    else
      render 'new'
    end
  end

  def edit
    @info = Information.find(params[:id])
  end

  def update
    @info = Information.find(params[:id])
    if @info.update(info_params)
      redirect_to admin_information_index_path
    else
      render 'edit'
    end
  end

  def destroy
    @info = Information.find(params[:id])
    @info.destroy
    respond_to do |format|
      format.html { redirect_to admin_information_index_path }
      format.js { render :action => "destroy" }
    end
  end

  def search
    is_pagination?(params)
    if params[:q]['title_or_contents_cont_any'] != nil
      params[:q]['title_or_contents_cont_any'] = params[:q]['title_or_contents_cont_any'].split(/[ ]/)
      @keywords = Information.ransack(params[:q])
      @information = @keywords.result.page(params[:page])
      @q = Information.ransack(params[:q])
    else
      @q = Information.ransack(params[:q])
      @information = @q.result(distinct: true).page(params[:page])
    end
    render template: 'admin/information/index'
  end

  private
  
  def info_params
    params.require(:information).permit(:title, :contents, :status)
  end
end
