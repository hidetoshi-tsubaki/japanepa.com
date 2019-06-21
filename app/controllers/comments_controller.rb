class CommentsController < ApplicationController

  
  def create
    # pry-bye
    comment = current_user.comments.new(comment_params)
    #   talk IDを取り出して、それで検索する
    if comment.save
        @comments = Comment.where(talk_id: comment_params[:talk_id] ).order('created_at DESC')
        @comment = Comment.new()
    else
      render 'talk/show'
    end
  end

  def edit
    @comment = Comment.new
  end

  def update
     Comment.update(comment_params)
  end

  def delete
    Comment.find(params[:id]).destroy
  end

  def sort
    @communities = Community.all
  end
  private
    def comment_params
      params.require(:comment).permit(:talk_id,:contents)
    end
end
