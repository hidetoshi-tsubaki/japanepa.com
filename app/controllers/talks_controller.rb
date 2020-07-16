class TalksController < ApplicationController
  before_action :only_login_user!
  before_action :get_unchecked_announce_count, :get_not_done_reviews_count, :get_current_level
  before_action :set_ranked_talks, only: [:feed]
  before_action :from_feed?, only: [:new, :edit, :create, :edit]
  before_action :get_community_id, only: [:new, :edit, :create]
  before_action :get_joined_communties

  def feed
    @talks = Talk.in_joined_communities(current_user)
    @comment = Comment.new
    @tags = Community.tags_on(:tags)
  end

  def show
    @talk = Talk.includes(:user).find(params[:id])
    @comments = @talk.comments.includes(:users).sort_and_page(10)
    @comment = Comment.new
  end

  def new
    @talk = current_user.talks.new
  end

  def create
    @talk = current_user.talks.new(talk_params)
    if @talk.save
      flash.now[:notice] = "talk was post"
      redirect_to_the_page
    else
      @community = Community.find(params[:talk][:community_id].to_i) if params[:feed].blank?
      render 'new'
    end
  end

  def edit
    @talk = Talk.find(params[:id])
  end

  def update
    @talk = Talk.find(params[:id])
    if @talk.update(talk_params)
      @talk.img.purge if params[:talk][:delete_img].present?
      redirect_to_the_page
    else
      @community = Community.find(params[:talk][:community_id].to_i)
      render 'edit'
    end
  end

  def destroy
    @talk = Talk.find(params[:id])
    @talk.destroy
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

  def get_community_id
    if params[:from_feed] == "true"
      @communities = current_user.communities
    else
      @community = Community.find(params[:from_community_page])
    end
  end

  def from_feed?
    @from_feed = params[:from_feed]
  end

  def redirect_to_the_page
    unless params[:from_feed].blank?
      redirect_to feed_talk_path(current_user)
    else
      redirect_to community_path(@talk.community)
    end
  end

  def set_ranked_talks
    @commented_top_3 = Talk.commented_top_3
    @liked_top_3 = Talk.liked_top_3
  end

  def get_joined_communties
    @joined_communities = current_user.communities
  end

end
