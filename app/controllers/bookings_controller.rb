class BookingsController < ApplicationController
  before_action :set_room, only: [:new, :confirmation]
  before_action :set_inn, only: [:new, :confirmation]

  def new
    @pre_booking = Booking.new
  end

  def confirmation
    @pre_booking = Booking.new(pre_booking_params)

    render "new" unless @pre_booking.valid?

    # return redirect_to new_room_booking_path(@room), alert: I18n.t("date_conflict") if @pre_booking.dates_conflict?
    # return redirect_to new_room_booking_path(@room), alert: I18n.t("too_many_guests") if @pre_booking.too_many_guests?
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
