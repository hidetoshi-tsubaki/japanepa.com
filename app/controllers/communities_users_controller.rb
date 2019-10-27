class CommunitiesUsersController < ApplicationController
  before_action :authenticate_user!

  def join
    @community = Community.find(params[:id])
    current_user.join(@community)
  end

  def leave
    @community = Community.find(params[:id])
    current_user.leave(@community)
  end
end
