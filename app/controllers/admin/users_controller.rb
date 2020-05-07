class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).paginate(params[:page], 15)
  end
  
  def show
    @user = User.find(params[:id])
    get_user_level(@user)
  end

  def search
    if params[:q]['name_cont_any'] != nil
      params[:q]['name_cont_any'] = params[:q]['name_cont_any'].split(/[ ]/)
      @keywords = User.ransack(params[:q])
      @users = @keywords.result.paginate(params[:page], 15)
      @q = User.ransack(params[:q])
    else
      @q = User.ransack(params[:q])
      @users = @q.result(distinct: true).paginate(params[:page], 15)
    end
    render template: 'admin/users/index'
  end

end
