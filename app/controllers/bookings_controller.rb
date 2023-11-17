class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :cancel]
  before_action :set_room, only: [:new, :create, :confirmation]
  before_action :set_inn, only: [:new, :confirmation]
  before_action :authenticate_user!, only: [:my_bookings, :create, :cancel]
  before_action :authenticate_owner!, only: [:index]
  before_action :authenticate_user_or_owner, only: [:show]

  def index
    @inn = current_owner.inn
    @bookings = @inn.bookings
  end

  def new
    @pre_booking = Booking.new
  end

  def confirmation
    @pre_booking = Booking.new

    if session["pre_booking"]
      @pre_booking.assign_attributes(session_params)
    else
      @pre_booking = Booking.new(pre_booking_params)
    end

    if @pre_booking.valid?
      session["pre_booking"] ||= pre_booking_params
    else
      render "new"
    end
  end

  def create
    @booking = @room.bookings.build()

    if session["pre_booking"]
      # debugger
      @booking.assign_attributes(session_params)
    end

    @booking.user = current_user

    if @booking.save
      session.delete("pre_booking")
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

  def authenticate_user_or_owner
    unless user_signed_in? || owner_signed_in?
      redirect_to login_path, notice: "Faça log-in para continuar"
    end
  end

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

  def session_params
    { start_date: Date.parse(session.dig("pre_booking", "start_date")),
      end_date: Date.parse(session.dig("pre_booking", "end_date")),
      number_of_guests: session.dig("pre_booking", "number_of_guests").to_i,
      room_id: session.dig("pre_booking", "room_id").to_i }
  end
end
