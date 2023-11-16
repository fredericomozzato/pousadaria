class BookingsController < ApplicationController
  before_action :set_room, only: [:new, :confirmation]
  before_action :set_inn, only: [:new, :confirmation]

  def new
    @pre_booking = Booking.new
  end

  def confirmation
    @pre_booking = Booking.new(pre_booking_params)
    render "new" unless @pre_booking.valid?
  end

  def create
    redirect_to new_user_session_path unless user_signed_in?


  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def set_inn
    @inn = @room.inn
  end

  def pre_booking_params
    params.permit(:start_date, :end_date, :number_of_guests, :room_id)
  end
end
