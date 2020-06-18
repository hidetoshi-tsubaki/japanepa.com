class LikeTalksController < ApplicationController
  before_action :only_login_user!

  def create
    current_user.like_talk(params[:id]) if can_like?(params[:id])
    @talk = Talk.find(params[:id])
    render "like"
  end

  def destroy
    current_user.remove_like_talk(params[:id]) if can_like?(params[:id])
    @talk = Talk.find(params[:id])
    render "like"
  end

  private

  def can_like?(talk_id)
    current_user.id != talk_id
  end
end
