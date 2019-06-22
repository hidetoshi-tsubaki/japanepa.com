class CommunitiesController < ApplicationController
  include CommunitiesHelper
  before_action  :past_30days_after_signIn?, only: [:new ,:create]
  
  # これはコミュニティーの一覧、フィード画面へのアクションが必要
  def index
    @communities = Community.includes(:talks).all
  #community.users.size
  end

  def feed
    joinedCommunity = current_user.communities.pluck(:id)
    @talks = Talk.where(community_id: joinedCommunity).order('created_at DESC').page(params[:page]).per(10)
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
    @talks = Talk.includes(:user).where(community_id:params[:id]).order('created_at DESC').page(params[:page]).per(10)
    # もしくはtalk.where("community_id = params[id]")
  end

  def edit
    @community = Community.find(params[:id])
  end


  def update
    if Community.update(community_params)
      flash.now[:notice]="community was updated"
    end
  end

  def delete
    if Community.find(params[:id]).destroy
      @community = Community.order('created_at DESC').page(params[:page]).per(9)
      render :index
    else
      flash.now[:notice]="failed to delete... try again"
      render :index
    end
  end

  def sort
    # pry-byebug
    @communities = Community.sorted_by(params[:sort])
  end

  def search
     @communities = Community.search(params[:keyword])
  end

  private

    def community_params
      params.require(:community).permit(:name,:img,:introduction,:user_id)
    end


end
