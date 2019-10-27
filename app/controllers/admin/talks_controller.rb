class Admin::TalksController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_edit_delete, only: :delete
  # もしも、communityに参加していなかった時のためのbefore_action

  def new
    @talk = current_user.talks.new
    @community = Community.find_by(id: params[:id]) || @communities = current_user.community_users.includes(:community)
    render :modal_talk_form
  end
  
  def index
    if params[:q] != nil
      params[:q]['name_or_introduction_cont_any'] = params[:q]['title_or_lead_cont_any'].split(/[ ]/)
      @keywords = Talk.ransack(params[:q])
      @talks = @keywords.result.sorted.page(params[:page])
      @q = Talk.ransack(params[:q])
    else
      @q = Talk.ransack(params[:q])
      @talks = @q.result(distinct: true).sorted.page(params[:page])
    end
  end

  def show
    @talk = Talk.includes(:user).find(params[:id])
    @comments = @talk.comments.includes(:users).sort_and_paginate(10)
    # @comment = @talk.comments.new(user_id: current_user.id) if current_user
    @comment = Comment.new
  end

  def create
    @talk = Talk.new(talk_params)
    if @talk.save
      flash.now[:notice] = "talk was post"
      @talks = Talk.order('created_at DESC').page(params[:page])
      @communities = current_user.community_users.includes(:community)
      render :update_index
    else
      flash.now[:notice] = "failed to post.... try again"
      @communities = current_user.community_users.includes(:community)
      render :index
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
      @communities = current_user.community_users.includes(:communities)
      joined_communities_Id = current_user.community_users
      @talks = Talk.where(community_id: joined_communities_Id).sorted.page(params[:page])
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

  def talks_in_feed(communities)
    if communities.empty?
      Talk.sorted
    else
      community_id = communities.map{ |community| community.id }
      Talk.where(id: community_id).precount(:comments)
    end
  end
end
