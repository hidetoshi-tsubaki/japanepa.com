class Admin::CommunitiesController < ApplicationController
  include CommunitiesHelper
  before_action :authenticate_admin!
  before_action :set_community_tags, only: [:index, :search, :tag_search]
  before_action :set_available_tags_to_gon, only: [ :edit, :confirm ]

  def index
    @q = Community.includes(:founder).ransack(params[:q])
    @communities = @q.result(distinct: true).paginate(params[:page], 15)
  end

  def show
    @community = Community.find(params[:id])
    @talks = Talk.includes(:users).where(community_id: params[:id])
  end

  def edit
    @community = Community.find(params[:id])
    gon.community_tags = @community.tag_list
  end

  def update
    @community = Community.find(params[:id])
    @community.update(community_params)
    if @community.save
      redirect_to admin_communities_path
      flash.now[:notice] = "community was updated"
    else
      render 'edit'
    end
  end

  def destroy
    @community = Community.find(params[:id]).destroy
  end

  def tag_search
    @communities = Community.tagged_with(params[:tag]).paginate(params[:page], 15)
    @q = Community.ransack(params[:q])
    render template: 'admin/communities/index'
  end

  def search
    is_pagination?(params)
    if params[:q]['name_or_introduction_or_founder_name_cont_any'] != nil
      params[:q]['name_or_introduction_or_founder_name_cont_any'] = params[:q]['name_or_introduction_or_founder_name_cont_any'].split(/[ ]/)
      @keywords = Community.ransack(params[:q])
      @communities = @keywords.result.sorted.paginate(params[:page], 15)
      @q = Community.ransack(params[:q])
    else
      @q = Community.ransack(params[:q])
      @communities = @q.result(distinct: true).sorted.paginate(params[:page], 15)
    end
    render template: 'admin/communities/index'
  end

  private

  def community_params
    params.require(:community).permit(:name, :img, :introduction, :user_id, :tag_list)
  end

  def set_available_tags_to_gon
    gon.available_tags = Community.tags_on(:tags).pluck(:name)
  end


  def set_community_tags
    @tags = Community.all_tags
  end

  def is_pagination?(params)
    if params[:q]['title_or_lead_cont_any'].kind_of?(Array)
      params[:q]['title_or_lead_cont_any'] = params[:q]['title_or_lead_cont_any'].join(" ")
    end
  end

end
