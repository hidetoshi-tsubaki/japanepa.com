class CommunitiesController < ApplicationController
  include CommunitiesHelper
  before_action :only_login_user!
  # before_action :past_30days_after_signIn?, only: [:new, :create]
  before_action :set_community_tags, only: [:index, :search, :tag_search]

  def index
    @q = Community.ransack(params[:q])
    @communities = @q.result(distinct: true).sorted
    @comment = Comment.new
  end

  def show
    @community = Community.includes([:founder, talks: :user]).find_by_id(params[:id])
    @talks = Talk.where(community_id: params[:id])
    @tags = @community.tags_on(:tags)
    @comment = Comment.new
    @commented_top_3 = @community.talks.commented_top_3
    @liked_top_3 = @community.talks.liked_top_3
  end

  def new
    @community = Community.new
    gon.available_tags = Community.tags_on(:tags).pluck(:name)
  end

  def create
    begin
      @community = current_user.communities.new(community_params)
    rescue => e
      redirect_to root_path
    end
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
    if @community.update(community_params) && current_user.is_founder?(@community)
      flash.now[:notice] = "community was updated"
      redirect_to community_path(@community)
    else
      render 'edit'
    end
  end

  def destroy
    @community = Community.find_by_id(params[:id])
    @community.destroy if current_user.is_founder?(@community)
    redirect_to communities_path
  end

  def feed
    joined_Community = current_user.community_users.pluck(:community_id)
    @talks = Talk.where(community_id: joined_Community).includes(:community).sort_and_paginate(10)
    @comment = Comment.new
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
    params.require(:community).permit(:name, :img, :introduction, :founder_id)
  end

  def set_community_tags
    @tags = Community.all_tags
  end

end
