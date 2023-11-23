class Api::V1::BookingsController < Api::V1::ApiController
  def pre_booking
    pre_booking = Booking.new(pre_booking_params)

    if pre_booking.valid?
      render status: 200, json: {"valor": pre_booking.calculate_bill}
    else
      render status: 409, json: {"erro": pre_booking.errors.full_messages}
    end
  end

  private

  def pre_booking_params
    params.permit(
      :room_id,
      :start_date,
      :end_date,
      :number_of_guests
    )
  end
end
