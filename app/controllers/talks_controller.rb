class TalksController < ApplicationController
  before_action :only_login_user!
  before_action :get_unchecked_announce_count, :get_not_done_reviews_count
  before_action :set_ranked_talks, only: [:feed]
  before_action :which_page?, only: [:new, :edit, :create, :edit, :update]
  before_action :get_community_id, only: [:new, :edit, :create, :update]
  before_action :get_joined_communties

  def feed
    @talks = Talk.includes([:user, :community]).in_joined_communities(current_user)
    @comment = Comment.new
    @tags = Community.tags_on(:tags)
  end

  def new
    @talk = current_user.talks.new
  end

  def create
    @talk = current_user.talks.new(talk_params)
    if @talk.save
      redirect_to community_path(@talk.community)
    else
      render :new
    end
  end

  def show
  end

  def edit
    @talk = Talk.find(params[:id])
  end

  def update
    @talk = Talk.find(params[:id])
    if @talk.update(talk_params)
      @talk.img.purge if params[:talk][:delete_img].present?
      redirect_to community_path(@talk.community, anchor: "talk_#{@talk.id}")
    else
      @community = @talk.community
      render :edit
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
    unless user_signed_in?
      render :index
      flash.now[:notice] = "you don't have right to delete...."
    end
  end

  def get_community_id
    if params[:community_page?].present?
      @community = Community.find(params[:community_page?])
    else
      @communities = current_user.communities
    end
  end

  def which_page?
    if params[:community_page?].present?
      @community_page = Community.find(params[:community_page?]).id
    else
      @community_page = nil
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
