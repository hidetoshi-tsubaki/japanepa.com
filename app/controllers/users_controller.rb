class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.includes(:user_total_experiences)
            .order("user_total_experiences.total_experience desc")
  end

  def show
    @user = User.find(params[:id])
    get_user_level
  end
end
