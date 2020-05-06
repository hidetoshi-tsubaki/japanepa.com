class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @q = User.ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end

  def search
    if params[:q]['name_cont_any'] != nil
      params[:q]['name_cont_any'] = params[:q]['name_cont_any'].split(/[ ]/)
      @keywords = User.ransack(params[:q])
      @users = @keywords.result.page(params[:page])
      @q = User.ransack(params[:q])
    else
      @q = User.ransack(params[:q])
      @users = @q.result(distinct: true).page(params[:page])
    end
    render template: 'admin/users/index'
  end

end
