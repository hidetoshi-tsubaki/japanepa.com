class CommunitiesController < ApplicationController
  include CommunitiesHelper
  before_action :authenticate_user!, only: [:create, :edit, :update, :delete]
  before_action :past_30days_after_signIn?, only: [:new, :create]

  def index
    @communities = Community.includes(:talks).order('created_at desc')
    # community.users.size
  end

  def feed
    joined_Community = current_user.community_users.pluck(:community_id)
    @talks = Talk.where(community_id: joined_Community).includes(:community).sort_and_paginate(10)
  end

  def new
    @community = Community.new
  end

  def create
    @community = current_user.communities.new(community_params)
    if @community.save
      current_user.join(@community)
      redirect_to show_community_path(@community)
    else
      render 'new.js.erb'
    end
  end

  def show
    @community = Community.find(params[:id])
    @talks = Talk.includes(:users).where(community_id: params[:id]).sort_and_paginate(10)
    # もしくはtalk.where("community_id = params[id]")
  end

  def edit
    @community = Community.find(params[:id])
  end

  def update
    if Community.update(community_params)
      flash.now[:notice] = "community was updated"
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
    params.require(:community).permit(:name, :img, :introduction, :user_id)
  end

end
