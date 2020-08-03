class RoomsController < ApplicationController
	before_action :authenticate_user!

	def create
		@room = Room.create
		@entry = Entry.create(:room_id => @room.id, :user_id => current_user.id)
		@entry_params = Entry.create(params.require(:entry).permit(:user_id, :room_id).merge(:room_id => @room.id))
    	redirect_to "/rooms/#{@room.id}"
	end

	def show
	  @room = Room.find(params[:id])
	  if Entry.where(:user_id => current_user.id, :room_id => @room.id).present?
	      @messages = @room.messages
	      @message = Message.new
	      @partner = @room.partner(current_user)
	  else
	      redirect_back(fallback_location: root_path)
	  end
	end

	def index
		@response = []
		my_entries = Entry.where(user_id: current_user.id)
		my_entries.each do |entry|
			room_info_for_response = {}
			room_info_for_response[:room] = entry.room.id
			room_info_for_response[:partner] = Entry.where(room_id: entry.room.id).where.not(user_id: current_user.id)[0].user
			room_info_for_response[:latest_message] = Message.where(room_id: entry.room.id).last
			@response << room_info_for_response
		end
	end
end
