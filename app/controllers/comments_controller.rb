class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    comment = current_user.comments.new(comment_params)
    talk = Talk.find(comment_params[:talk_id])
    if comment.save
      @comments = Comment.where(talk_id: comment_params[:talk_id]).sorted..page(params[:page])
      @comment = talk.comments.new
      @talk = Talk.find(comment_params[:talk_id])
      render :update_index
    else
      render 'talk/show'
    end
  end

  def edit
    @comment = Comment.find(params[:id])
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
