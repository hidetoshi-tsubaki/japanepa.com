class LikesTalksController < ApplicationController

  def like
    @talk = Talk.find(params[:id])
    current_user.like_talk(@talk)
  end

  def remove_like
    @talk = Talk.find(params[:id])
    current_user.remove_like_talk(@talk)
    render:like
    # 修正必要 分岐
  end
end
