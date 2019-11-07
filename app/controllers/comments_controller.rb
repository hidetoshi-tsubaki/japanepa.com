class CommentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @talk = Talk.find(params[:id])
    @comment = current_user.comments.new
    render :form
  end

  def create
    @comment = current_user.comments.new(comment_params)
    @talk = Talk.find(comment_params[:talk_id])
    if @comment.save
    else
      render :form
    end
  end

  def edit
    @comment = Comment.find(params[:id])
    render :form
  end

  def update
    Comment.update(comment_params)
    render :update_index
  end

  def delete
    Comment.find(params[:id]).destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:talk_id, :contents)
  end

end
