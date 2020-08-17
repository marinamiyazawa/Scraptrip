class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(6)
    if @user != current_user
      @posts = @user.posts.published.order("created_at DESC").page(params[:page]).per(6)
      end
    # google_map
    @hash = Gmaps4rails.build_markers(@posts) do |post, marker|
      marker.lat post.latitude
      marker.lng post.longitude
      marker.infowindow post.title
    end
    # DMページ
    @current_user_entry = Entry.where(user_id: current_user.id)
    @user_entry = Entry.where(user_id: @user.id)
    if @user.id == current_user.id
    else
      @current_user_entry.each do |cu|
        @user_entry.each do |u|
          if cu.room_id == u.room_id
            @is_room = true
            @room_id = cu.room_id
          end
        end
      end
      if @is_room
      else
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = 'ユーザー情報を編集しました'
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def hide
  end

  def hide_update
    @user = current_user
    @user.update(user_status: true)
    reset_session
    redirect_to root_path
  end

  def following
    @user = User.find(params[:id])
    @users = @user.followings
    render 'show_follow'
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    render 'show_follower'
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :nick_name, :introduction, :image, :user_status)
  end
end
