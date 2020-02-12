class Admin::TalksController < ApplicationController
  before_action :authenticate_admin!

  def index
    @q = Talk.includes([:user, :community]).ransack(params[:q])
    @talks = @q.result(distinct: true).sorted.page(params[:page])
  end

  def show
    @talk = Talk.find(params[:id])
  end

  def destroy
    talk = Talk.find(params[:id])
    @talk = talk
    talk.destroy
  end

  def search
    is_pagination?(params)
    if params[:q]['community_name_or_user_name_or_content_cont_any'] != nil
      params[:q]['community_name_or_user_name_or_content_cont_any'] = params[:q]['community_name_or_user_name_or_content_cont_any'].split(/[ ]/)
      @keywords = Talk.includes([:user, :community]).ransack(params[:q])
      @talks = @keywords.result.sorted.page(params[:page])
      @q = Talk.includes([:user, :community]).ransack(params[:q])
    else
      @q = Talk.includes([:user, :community]).ransack(params[:q])
      @talks = @q.result(distinct: true).sorted.page(params[:page])
    end
    render template: 'admin/talks/index'
  end

  private

  def talk_params
    params.require(:talk).permit(:user_id, :community_id, :content, :img)
  end

  def authenticate_edit_delete
    unless user_signed_in? || admin_signed_in?
      render :index
      flash.now[:notice] = "you don't have right to delete...."
    end
  end

  def is_pagination?(params)
    if params[:q]['user_name_or_content_cont_any'].kind_of?(Array)
      params[:q]['user_name_or_content_cont_any'] = params[:q]['user_name_or_content_cont_any'].join(" ")
    end
  end
end
