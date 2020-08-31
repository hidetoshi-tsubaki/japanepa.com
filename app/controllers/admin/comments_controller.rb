class Admin::CommentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @q = Comment.ransack(params[:q])
    @comments = Comment.includes(:user).
      paginate(params[:page], 15)
  end

  def show
    @comment = Comment.find(params[:id])
    @talk = @comment.talk
    @comments = @talk.comments.includes(:users)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to admin_comments_path }
      format.js { render :action => "destroy" }
    end
  end

  def search
    is_pagination?(params)
    if !params[:q]['user_name_or_contents_cont_any'].nil?
      params[:q]['user_name_or_contents_cont_any'] = params[:q]['user_name_or_contents_cont_any'].split(/[ ]/)
      @keywords = Comment.ransack(params[:q])
      @comments = @keywords.result.paginate(params[:page], 15)
      @q = Comment.ransack(params[:q])
    else
      @q = Comment.ransack(params[:q])
      @comment = @q.result(distinct: true).paginate(params[:page], 15)
    end
    render template: 'admin/comments/index'
  end

  private

  def is_pagination?(params)
    if params[:q]['user_name_or_contents_cont_any'].is_a?(Array)
      params[:q]['user_name_or_contents_cont_any'] = params[:q]['user_name_or_contents_cont_any'].join(" ")
    end
  end
end
