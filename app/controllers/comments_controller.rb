class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @talk = Talk.find(params[:id])
    @comments = @talk.comments.sorted.page(params[:page])
  end

  def create
    @comment = current_user.comments.new(comment_params)
    @talk = Talk.find(comment_params[:talk_id])
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update(comment_params)
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
