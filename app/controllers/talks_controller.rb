class TalksController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :delete]
  # before_action :authenticate_edit_delete, only: :delete
  # もしも、communityに参加していなかった時のためのbefore_action
  before_action :set_ranked_talks, only: [:index]

  def new
    @talk = current_user.talks.new
    @communities = current_user.communities
    render 'form'
  end
  
  def index
    @talks = current_user.own_talks.sorted.page(params[:page])
    @comment = Comment.new
  end

  def show
    @talk = Talk.includes(:user).find(params[:id])
    @comments = @talk.comments.includes(:users).sort_and_paginate(10)
    @comment = Comment.new
  end

  def create
    @talk = current_user.talks.new(talk_params)
    if @talk.save
      flash.now[:notice] = "talk was post"
    else
      @communities = current_user.communities
      render 'form'
    end
  end

  def edit
    @talk = Talk.find(params[:id])
    @communities = current_user.communities
    render 'form'
  end

  def update
    @talk = Talk.find(params[:id])
    if @talk.update(talk_params)
      flash.now[:notice] = "talk was updated"
    else
      flash.now[:alert] = "failed to update.... try again"
      render :edit
    end
  end

  def destroy
    @talk = Talk.find(params[:id])
    @talk.destroy
  end

  def destroy_img
    @talk = Talk.find(params[:id])
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
    def set_ranked_talks
    @commented_top_3 = Talk.commented_top_3
    @liked_top_3 = Talk.liked_top_3
  end

end
