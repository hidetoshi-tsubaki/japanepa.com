class CommunitiesUsersController < ApplicationController

  def create 
    @community = Community.find(params[:id])
    current_user.join(@community)
    redirect_to @community
  end

  def delete

  end

end
