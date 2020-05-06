class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @comments = Comment.includes(community: [:user, :talk])
    @comments = @comments.comments.paginate(params[:page], 15)
  end

  def show
    @comment = Comment.find(params[:id])
    @talk = Talk.includes(:user, :community)
  end

  def destory
    Comment.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_to admin_comments_path }
      format.js { render :action => "destroy"}
    end
  end
end