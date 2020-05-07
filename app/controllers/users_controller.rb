class UsersController < ApplicationController
  before_action :only_login_user!

  def index
    @users = User.includes(:user_experience)
            .order("user_experiences.total_point desc")
    get_current_level
  end

  def show
    if @user = User.find_by_id(params[:id])
      get_user_level(current_user)
    else
      redirect_to root_path
    end
  end

end
