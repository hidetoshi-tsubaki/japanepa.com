class LikeTalksController < ApplicationController
  before_action :only_login_user!

  def create
    @talk = Talk.find(params[:id])
    current_user.like_talk(@talk) if can_like?(@talk)
    render "like"
  end

  def destroy
    @talk = Talk.find(params[:id])
    current_user.remove_like_talk(@talk) if can_like?(@talk)
    render "like"
  end

  private

  def can_like?(talk)
    current_user.id != talk.user_id
  end
end
