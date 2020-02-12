class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.includes(:user_total_experiences)
            .order("user_total_experiences.total_experience desc")
  end

  def show
    if @user = User.find_by_id(params[:id])
      get_user_level
    else
      redirect_to root_path
    end
  end
end
