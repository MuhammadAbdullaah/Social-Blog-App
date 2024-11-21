class CommentsController < ApplicationController
  before_action :authenticate_user!  # Ensure user is logged in to comment
  before_action :authorize_comment_deletion, only: [ :destroy ]

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user  # Set the user who created the comment

    if params[:comment][:parent_id].present?  # Check if the comment is a reply
      @comment.parent_id = params[:comment][:parent_id]
    end

    if @comment.save
      redirect_to @post, notice: "Comment was successfully created."
    else
      redirect_to @post, alert: "Error creating comment."
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to post_path(@comment.post), notice: "Comment deleted successfully."
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def authorize_comment_deletion
    @comment = Comment.find(params[:id])
    unless current_user == @comment.user || current_user == @comment.post.user
      redirect_to post_path(@comment.post), alert: "You are not authorized to delete this comment."
    end
  end
end
