class UsersController < ApplicationController


	def show
		@user = User.find(params[:id])
		@posts = @user.posts
			 if @user != current_user
				@posts = @user.posts.published.order("created_at DESC")
			end
	
		@hash = Gmaps4rails.build_markers(@posts) do |post, marker|#google_map
		      marker.lat post.latitude
		      marker.lng post.longitude
		      marker.infowindow post.title
		    end
		@currentUserEntry = Entry.where(user_id: current_user.id) #DMページ
		@userEntry = Entry.where(user_id: @user.id)
		if @user.id == current_user.id
		else
			@currentUserEntry.each do |cu|
				@userEntry.each do |u|
					if cu.room_id == u.room_id then
						@isRoom = true
						@roomId = cu.room_id
					end
				end
			end
			if @isRoom
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
		@user.update!(user_params)
		redirect_to user_path(@user)
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
		params.require(:user).permit(:first_name,:last_name,:nick_name,:introduction,:image,:user_status)
	end
end
