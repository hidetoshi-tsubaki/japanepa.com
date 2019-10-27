class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
    get_user_level
  end
end
