class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin, only: [ :index, :edit, :update, :destroy ]

  def index
    @users = User.all
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path, notice: "User updated successfully"
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_path, notice: "User deleted successfully"
  end

  private

  def authorize_admin
    redirect_to root_path, alert: "Not authorized" unless current_user.admin?
  end

  def user_params
    params.require(:user).permit(:email, :admin)
  end
end
