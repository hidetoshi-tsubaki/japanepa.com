class CommunitiesController < ApplicationController
  include CommunitiesHelper
  before_action :only_login_user!
  before_action :get_unchecked_announce_count, :get_current_level
  # before_action :past_30days_after_signIn?, only: [:new, :create]
  before_action :get_community_tags, only: [:index, :search, :tag_search]
  before_action :get_available_tags, only: [:new, :edit]
  before_action :get_ranked_communities, only: [:show, :index, :search, :tag_search, :joined]
  before_action :get_joined_communities, only: [:index, :show, :joined]
  def index
    @q = Community.ransack(params[:q])
    @communities = @q.result(distinct: true).sorted
  end

  def show
    @community = Community.includes([:founder, talks: :user]).find(params[:id])
    @talks = Talk.where(community_id: params[:id])
    @tags = @community.tags_on(:tags)
    @comment = Comment.new
  end

  def new
    @community = Community.new
  end

  def create
    @community = current_user.communities.new(community_params)
    if @community.save
      current_user.join(@community)
      redirect_to community_path(@community)
    else
      render 'new'
    end
  end

  def edit
    @community = Community.find(params[:id])
    gon.community_tags = @community.tag_list
  end

  def update
    @community = Community.find(params[:id])
    if @community.update(community_params) && current_user.is_founder?(@community)
      @community.img.purge if params[:community][:delete_img]
      redirect_to community_path(@community)
    else
      render 'edit'
    end
  end

  def destroy
    @community = Community.find_by_id(params[:id])
    @community.destroy if current_user.is_founder?(@community)
    redirect_to communities_path
  end

  def joined
    @q = Community.ransack(params[:q])
    @communities = current_user.communities.limit(10)
    render template: 'communities/index'
  end

  def sort
    @communities = Community.sorted_by(params[:sort])
  end

  def tag_search
    @communities = Community.tagged_with(params[:tag])
    @q = Community.ransack(params[:q])
    render template: 'communities/index'
  end

  def search
    if params[:q] != nil
      params[:q]['name_or_introduction_cont_any'] = params[:q]['name_or_introduction_cont_any'].split(/[ ]/)
      @keywords = Community.ransack(params[:q])
      @communities = @keywords.result.sorted
      @q = Community.ransack(params[:q])
    else
      @q = Community.ransack(params[:q])
      @communities = @q.result(distinct: true).sorted
    end
    render template: 'communities/index'
  end

  private

  def community_params
    params.require(:community).permit(:name, :img, :introduction, :founder_id, :tag_list)
  end

  def get_community_tags
    @tags = Community.all_tags
  end

  def get_available_tags
    gon.available_tags = Community.tags_on(:tags).pluck(:name)
  end

  def get_ranked_communities
    @user_joined_top_3 = Community.user_joined_top_3
    @active_top_3 = Community.active_top_3
  end

  def get_joined_communities
    @joined_communities = current_user.communities
  end
end
