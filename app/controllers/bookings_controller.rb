class BookingsController < ApplicationController
  def new
    @room = Room.find(params[:room_id])
    @inn = @room.inn
  end

  def check_availability
    redirect_to new_user_session_path unless user_signed_in?
  end
end
