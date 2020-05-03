class CommunityUsersController < ApplicationController
  before_action :authenticate_user!

  def create
    @community = Community.find(params[:id])
    current_user.join(@community)
    render 'join'
  end

  def destroy
    @community = Community.find(params[:id])
    current_user.leave(@community)
    render 'join'
  end
end
