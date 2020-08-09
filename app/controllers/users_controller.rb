class UsersController < ApplicationController
  before_action :only_login_user!
  before_action :get_unchecked_announce_count, :get_not_done_reviews_count

  def index
    @users = User.includes(:user_experience)
            .order("user_experiences.total_point desc")
  end

  def show
    @user = User.find_by_id(params[:id])
  end

end
