class CommunitiesController < ApplicationController
  include CommunitiesHelper
  before_action :authenticate_user!
  # before_action :past_30days_after_signIn?, only: [:new, :create]
  before_action :set_community_tags, only: [:index, :search, :tag_search]

  def index
    @q = Community.ransack(params[:q])
    @communities = @q.result(distinct: true).sorted
  end

  def new
    @community = Community.new
    gon.available_tags = Community.tags_on(:tags).pluck(:name)
  end

  def create
    @community = current_user.communities.new(community_params)
    if @community.save
      current_user.join(@community)
      redirect_to community_path(@community)
    else
      render 'new'
    end
  end

  def edit
    @community = Community.find(params[:id])
    gon.community_tags = @community.tag_list
    gon.available_tags = Community.tags_on(:tags).pluck(:name)
  end

  def update
    @community = Community.find(params[:id])
    if @Community.update(community_params)
      flash.now[:notice] = "community was updated"
      redirect_to community_path(@community)
    else
      render 'edit'
    end
  end

  def feed
    joined_Community = current_user.community_users.pluck(:community_id)
    @talks = Talk.where(community_id: joined_Community).includes(:community).sort_and_paginate(10)
  end

  def show
    @community = Community.includes(:founder).find(params[:id])
    @talks = Talk.where(community_id: params[:id])
    @tags = @community.tags_on(:tags)
  end

  def sort
    @communities = Community.sorted_by(params[:sort])
  end

  def tag_search
    @communities = Community.tagged_with(params[:tag])
    @q = Community.ransack(params[:q])
    render template: 'communities/index'
  end

  def search
    if params[:q] != nil
      params[:q]['name_or_introduction_cont_any'] = params[:q]['name_or_introduction_cont_any'].split(/[ ]/)
      @keywords = Community.ransack(params[:q])
      @communities = @keywords.result.sorted
      @q = Community.ransack(params[:q])
    else
      @q = Community.ransack(params[:q])
      @communities = @q.result(distinct: true).sorted
    end
    render template: 'communities/index'
  end

  def join
    @community = Community.find(params[:id])
    current_user.join(@community)
  end

  def leave
    @community = Community.find(params[:id])
    current_user.leave(@community)
    render 'join'
  end

  private

  def community_params
    params.require(:community).permit(:name, :img, :introduction, :founder_id, :tag_list)
  end

  def set_community_tags
    @tags = Community.tags_on(:tags)
  end

end
