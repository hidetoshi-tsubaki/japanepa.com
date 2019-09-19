class Admin::CommunitiesController < ApplicationController
  include CommunitiesHelper
  before_action :authenticate_user!, only: [:create, :edit, :update, :delete]
  before_action :past_30days_after_signIn?, only: [:new, :create]

  def index
    if params[:tag].present?
      @communities = Community.tagged_with(:tag)
    else
      @communities = Community.sorted
    end
    @tags = Community.tags_on(:tags)
  end

  def new
    @community = Community.new
    gon.available_tags = Community.tags_on(:tags).pluck(:name)
  end

  def create
    @community = current_user.communities.new(community_params)
    if @community.save
      current_user.join(@community)
      redirect_to admin_community_path(@community)
    else
      render 'new'
    end
  end

  def show
    @community = Community.find(params[:id])
    @talks = Talk.includes(:users).where(community_id: params[:id])
  end

  def edit
    @community = Community.find(params[:id])
    gon.community_tags = @community.tag_list
    gon.available_tags = Community.tags_on(:tags).pluck(:name)
  end

  def update
    @community = Community.find(params[:id])
    if @community.update(community_params)
      redirect_to community_path(@community)
      flash.now[:notice] = "community was updated"
    else
      render 'edit'
    end
  end

  def delete
    if Community.find(params[:id]).destroy
      @community = Community.sort_and_paginate(9)
      render :index
    else
      flash.now[:notice] = "failed to delete... try again"
      render :index
    end
  end

  def sort
    @communities = Community.sorted_by(params[:sort])
  end

  def search
    @communities = Community.search(params[:keyword])
    render 'sort.js.erb'
  end

  private

  def community_params
    params.require(:community).permit(:name, :img, :introduction, :user_id, :tag_list)
  end

end
