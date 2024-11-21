class PostsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]


  def index
    @posts = Post.all
    if params[:query].present?
      @posts = Post.joins(:user)
                   .where("posts.title LIKE :query OR users.username LIKE :query", query: "%#{params[:query]}%")
                   .order(created_at: :desc)
    else
      @posts = Post.all.order(created_at: :desc)
    end
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit
    end
  end
  def destroy
    if @post.user == current_user || current_user.admin?
      @post.destroy
      redirect_to posts_path, notice: "Post was successfully deleted."
    else
      redirect_to posts_path, alert: "You are not authorized to delete this post."
    end
  end


  def my_posts
    @posts = current_user.posts
  end




  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :image)
  end
end
