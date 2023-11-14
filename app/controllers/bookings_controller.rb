class BookingsController < ApplicationController
  before_action :set_room, only: [:new, :confirmation]

  def new
    @inn = @room.inn
    @booking = Booking.new
  end

  def confirmation
    @pre_booking = Booking.new(pre_booking_params)
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def pre_booking_params
    params.permit(:start_date, :end_date, :number_of_guests, :room_id)
  end
end
