class TalksController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :delete]
  # before_action :authenticate_edit_delete, only: :delete
  # もしも、communityに参加していなかった時のためのbefore_action

  def new
    @talk = current_user.talks.new
    get_communities_select(params[:id])
  end
  
  def index
    @talks = talks_in_feed
    @tags = Community.tags_on(:tags)
  end

  def show
    @talk = Talk.includes(:user).find(params[:id])
    @comments = @talk.comments.includes(:users).sort_and_paginate(10)
    @comment = Comment.new
  end

  def create
    @talk = Talk.new(talk_params)
    if @talk.save!
      flash.now[:notice] = "talk was post"
      @talks = Talk.order('created_at DESC').page(params[:page]).per(10)
      @communities = current_user.community_users.includes(:community)
      render :index
    else
      @communities = current_user.communities
      render :new
    end
  end

  def edit
    @talk = Talk.find(params[:id])
    @community = Community.find(@talk.community_id)
    render :modal_talk_form
  end

  def update
    talk = Talk.find(params[:id])
    if talk.update(talk_params)
      flash.now[:notice] = "talk was updated"
      # get_joined_communities
      @communities = current_user.community_users.includes(:communities)
      # get_joined_communitiesId
      joined_communities_Id = current_user.community_users
      # get_talks
      @talks = Talk.where(community_id: joined_communities_Id).sort_and_paginate(10)
      # @talk = Talk.new
      render :update_index
    else
      flash.now[:alert] = "failed to update.... try again"
      render :edit
    end
  end

  def delete
    if Talk.find(params[:id]).destroy
      @talks = Talk.sort_and_paginate(10)
      render :update_index
    else
      flash.now[:notice] = "failed to delete..."
      render :index
    end
  end

  private

  def talk_params
    params.require(:talk).permit(:user_id, :community_id, :content, :img, :remove_img, :img_cache)
  end

  def authenticate_edit_delete
    unless user_signed_in? || admin_signed_in?
      render :index
      flash.now[:notice] = "you don't have right to delete...."
    end
  end

  def talks_in_feed
    if current_user.communities.empty?
      Talk.sorted
    else
      community_id = current_user.communities.pluck(:id)
      Talk.where(id: community_id)
    end
  end

  def get_communities_select(params)
    if params == "new"
      @communities = current_user.communities
    else
      @community = Community.find(params)
    end
  end
end
