class BookingsController < ApplicationController
  def new
    @room = Room.find(params[:room_id])
    @inn = @room.inn
  end
end
