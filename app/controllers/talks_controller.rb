class TalksController < ApplicationController
  before_action :authenticate_user!, only: :create
  before_action :authenticate_edit_delete ,only: :delete
  # もしも、communityに参加していなかった時のためのbefore_action
  
  def new
    @talk = Talk.new
    if params[:id]
      @community = Community.find(params[:id])
    else
      @communities = current_user.community_users.includes(:community)
    end
    @action = "Create!"
    # pry-byebug 
  end
  
  
  def index
    # get_joined_communities
    @communities= current_user.community_users.includes(:community)
    #get_joined_communitiesId
    joined_communitiesId = current_user.community_users
    #get_talks
    @talks = Talk.where(community_id: joined_communitiesId).order('created_at DESC').page(params[:page]).per(10)
    @talk =Talk.new
  end

  def show
    @talk = Talk.includes(:user).find(params[:id])
    @comments = @talk.comments.includes(:user).order('created_at DESC')
    # @comment = @talk.comments.new(user_id: current_user.id) if current_user
    @comment = Comment.new()
  end

  def create
    # @user = User.find(current_user.id)
    @talk = current_user.talks.new(talk_params)
    if @talk.save
      flash.now[:notice]="talk was post"
      @talks = Talk.order('created_at DESC').page(params[:page]).per(10)
      @communities= current_user.community_users.includes(:community)
      @talk = Talk.new
    else
      flash.now[:notice] = "failed to post.... try again"
      render :index
    end
  end

  def edit
    @talk = Talk.find(params[:id])
    render :form_talk
  end

  def update
    if Talk.update(talk_params)
      flash.now[:notice]="talk was updated"
    # get_joined_communities
    @communities= current_user.community_users.includes(:communities)
    #get_joined_communitiesId
    joined_communitiesId = current_user.community_users
    #get_talks
    @talks = Talk.where(community_id: joined_communitiesId).order('created_at DESC').page(params[:page]).per(10)
    @talk = Talk.new
      render :talk_after
    else
      flash.now[:notice]="failed to update.... try again"
      render :edit
    end
  end

  def delete
    if Talk.find(params[:id]).destroy
      @talks = Talk.order('created_at DESC').page(params[:page]).per(10)
      render :index
    else
      flash.now[:notice] ="failed to delete..."
      render :index
    end
  end

  private

    def talk_params
      params.require(:talk).permit(:community_id,:content, :img,:remove_img,:img_cache)
    end

    def authenticate_edit_delete
      unless user_signed_in? || admin_signed_in?
       render :index
       flash.now[:notice] = "you don't have right to delete...."
    end

  end

end
