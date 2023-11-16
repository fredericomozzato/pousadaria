class BookingsController < ApplicationController
  before_action :set_room, only: [:new, :create, :confirmation]
  before_action :set_inn, only: [:new, :confirmation]
  before_action :authenticate_user!, only: [:my_bookings, :create, :show]

  def new
    @pre_booking = Booking.new
  end

  def confirmation
    @pre_booking = Booking.new(pre_booking_params)
    render "new" unless @pre_booking.valid?
  end

  def create
    @booking = @room.bookings.build(booking_params)
    @booking.user = current_user

    if @booking.save
      redirect_to booking_path(@booking), notice: "Reserva confirmada"
    else
      render "confirmation"
    end
  end

  def show
    @booking = Booking.find(params[:id])
    @room = @booking.room
    @inn = @room.inn
  end

  def my_bookings
    @bookings = current_user.bookings
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

  def booking_params
    params.require(:booking)
          .permit(:start_date, :end_date, :number_of_guests, :room_id)
  end
end
