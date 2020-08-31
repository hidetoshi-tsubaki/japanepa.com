class Admin::AnnouncementsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @q = Announcement.ransack(params[:q])
    @announcements = @q.result(distinct: true).paginate(params[:page], 15)
  end

  def show
    @announce = Announcement.find(params[:id])
  end

  def new
    @announce = Announcement.new
  end

  def create
    @announce = Announcement.new(announce_params)
    if @announce.save
      redirect_to admin_announcements_path
    else
      render 'new'
    end
  end

  def edit
    @announce = Announcement.find(params[:id])
  end

  def update
    @announce = Announcement.find(params[:id])
    if @announce.update(announce_params)
      redirect_to admin_announcements_path
    else
      render 'edit'
    end
  end

  def destroy
    @announce = Announcement.find(params[:id])
    @announce.destroy
    respond_to do |format|
      format.html { redirect_to admin_announcements_path }
      format.js { render :action => "destroy" }
    end
  end

  def search
    is_pagination?(params)
    if !params[:q]['title_or_contents_cont_any'].nil?
      params[:q]['title_or_contents_cont_any'] = params[:q]['title_or_contents_cont_any'].split(/[ ]/)
      @keywords = Announcement.ransack(params[:q])
      @announcements = @keywords.result.paginate(params[:page], 15)
      @q = Announcement.ransack(params[:q])
    else
      @q = Announcement.ransack(params[:q])
      @announcements = @q.result(distinct: true).paginate(params[:page], 15)
    end
    render template: 'admin/announcements/index'
  end

  private

  def announce_params
    params.require(:announcement).permit(:title, :contents, :status)
  end

  def is_pagination?(params)
    if params[:q]['title_or_contents_cont_any'].is_a?(Array)
      params[:q]['title_or_contents_cont_any'] = params[:q]['title_or_contents_cont_any'].join(" ")
    end
  end
end
