class LikeTalksController < ApplicationController
  before_action :only_login_user!

  def create
    @talk = Talk.find(params[:id])
    current_user.like_talk(@talk)
    render "like"
  end

  def destroy
    @talk = Talk.find(params[:id])
    current_user.remove_like_talk(@talk)
    render "like"
    # 修正必要 分岐
  end
end
