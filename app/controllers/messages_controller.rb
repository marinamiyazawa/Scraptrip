class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    if Entry.where(:user_id => current_user.id, :room_id => params[:message][:room_id]).present?
      if @message = Message.create(params.require(:message).permit(:user_id, :content, :room_id).merge(:user_id => current_user.id))
        redirect_to room_path(@message.room_id)
      else
        render 'rooms/show'
      end
    else
      redirect_to referer
    end
  end
end
