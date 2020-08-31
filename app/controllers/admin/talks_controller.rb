class Admin::TalksController < ApplicationController
  before_action :authenticate_admin!

  def index
    @q = Talk.includes([:user, :community]).ransack(params[:q])
    @talks = @q.result(distinct: true).paginate(params[:page], 15)
  end

  def show
    @talk = Talk.find(params[:id])
    @comments = @talk.comments
  end

  def destroy
    @talk = Talk.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to admin_talks_path }
      format.js { render :action => "destroy" }
    end
  end

  def search
    is_pagination?(params)
    if !params[:q]['community_name_or_user_name_or_content_cont_any'].nil?
      params[:q]['community_name_or_user_name_or_content_cont_any'] = params[:q]['community_name_or_user_name_or_content_cont_any'].split(/[ ]/)
      @keywords = Talk.includes([:user, :community]).ransack(params[:q])
      @talks = @keywords.result.paginate(params[:page], 15)
      @q = Talk.includes([:user, :community]).ransack(params[:q])
    else
      @q = Talk.includes([:user, :community]).ransack(params[:q])
      @talks = @q.result(distinct: true).paginate(params[:page], 15)
    end
    render template: 'admin/talks/index'
  end

  def comments
    @talk = Talk.find(params[:id])
    @comments = @talk.comments.paginate(params[:page], 15)
  end

  private

  def talk_params
    params.require(:talk).permit(:user_id, :community_id, :content, :img)
  end

  def is_pagination?(params)
    if params[:q]['user_name_or_content_cont_any'].is_a?(Array)
      params[:q]['user_name_or_content_cont_any'] = params[:q]['user_name_or_content_cont_any'].join(" ")
    end
  end
end
