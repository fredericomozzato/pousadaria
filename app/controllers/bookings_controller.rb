class BookingsController < ApplicationController
  before_action :set_room, only: [:new, :confirmation]

  def new
    @inn = @room.inn
    @booking = Booking.new
  end

  def confirmation
    @pre_booking = Booking.new(pre_booking_params)

    if @pre_booking.dates_conflict?
      redirect_to new_room_booking_path(@room), alert: "Já existe uma reserva para este quarto no período selecionado"
    end
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  end

  def pre_booking_params
    params.permit(:start_date, :end_date, :number_of_guests, :room_id)
  end
end
