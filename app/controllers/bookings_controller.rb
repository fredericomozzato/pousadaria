class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :cancel]
  before_action :set_room, only: [:new, :create, :confirmation]
  before_action :set_inn, only: [:new, :confirmation]
  before_action :authenticate_user!, only: [:my_bookings, :create, :show, :cancel]

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
    @room = @booking.room
    @inn = @room.inn
  end

  def my_bookings
    @bookings = current_user.bookings
  end

  def cancel
    if current_user&.== @booking.user
      @booking.canceled! if @booking.confirmed? && @booking.cancel_date > Date.today
      redirect_to booking_path(@booking), notice: "Reserva cancelada"
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

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
