class CommentsController < ApplicationController
  before_action :only_login_user!

  def index
    @talk = Talk.find(params[:id])
    @comments = @talk.comments.paginate(params[:page], 15)
  end

  def create
    @comment = current_user.comments.new(comment_params)
    unless @comment.save
      render 'form'
    end
    @talk = @comment.talk
  end

  def edit
    @comment = Comment.find(params[:id])
    @talk = Talk.find(@comment.talk_id)
  end

  def update
    @comment = Comment.find(params[:id])
    unless @comment.update(comment_params)
      render 'form'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:talk_id, :contents)
  end
end
