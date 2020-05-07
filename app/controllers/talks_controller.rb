class TalksController < ApplicationController
  before_action :only_login_user!
  before_action :set_ranked_talks, only: [:index]
  before_action :from_feed?, :get_community_id, only: [:new, :create, :edit]

  def index
    @talks = current_user.own_talks.paginate(params[:page], 15)
    @comment = Comment.new
  end

  def feed
    @talks = Talk.in_joined_communities(current_user)
    @tags = Community.tags_on(:tags)
  end

  def show
    @talk = Talk.includes(:user).find(params[:id])
    @comments = @talk.comments.includes(:users).sort_and_page(10)
    @comment = Comment.new
  end

  def new
    @talk = current_user.talks.new
    render 'form'
  end

  def create
    @talk = current_user.talks.new(talk_params)
    if @talk.save
      flash.now[:notice] = "talk was post"
    else
      render 'form'
    end
  end

  def edit
    @talk = Talk.find(params[:id])
    render 'form'
  end

  def update
    @talk = Talk.find(params[:id])
    if @talk.update(talk_params)
      @talk.img.purge if params[:talk][:delete_img].present?
    else
      @community = Community.find(params[:talk][:community_id])
      render 'form'
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

  def talks_in_feed
    if current_user.communities.empty?
      Talk.sorted
    else
      community_id = current_user.communities.ids
      Talk.where(id: community_id)
    end
  end

  def get_community_id
    if params[:from_feed] == "true"
      @communities = current_user.communities
    else
      @community = Community.find(params[:talk][:community_id])
    end
  end

  def from_feed?
    @from_feed = params[:from_feed]
  end

  def set_ranked_talks
    @commented_top_3 = Talk.commented_top_3
    @liked_top_3 = Talk.liked_top_3
  end

end
