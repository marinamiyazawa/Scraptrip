class Admins::UsersController < ApplicationController
  def index
    @users = User.all.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to admins_user_path(@user)
  end

  private

  def user_params
    params.require(:user).permit(:image, :first_name, :last_name, :nick_name, :introduction, :email, :user_status)
  end
end
