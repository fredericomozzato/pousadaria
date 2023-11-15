class Booking < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validate :dates_conflict?

  enum status: {confirmed: 0, active: 5, closed: 10, canceled: 15}

  def calculate_bill
    room = Room.find(room_id)
    booking_range = start_date...end_date
    total_booking_days = booking_range.count
    total_bill = total_booking_days * room.price
    overlapping_days = 0

    room.seasonal_prices.each do |price|
      price_range = price.start..price.end

      if booking_range.overlaps? price_range
        intersection = (
          [booking_range.begin, price_range.begin].max...[booking_range.end, price_range.end].min
        )
        intersecting_days = intersection.count
        intersecting_days += 1 if booking_range.count > price_range.count
        total_bill -= intersecting_days * room.price
        total_bill += intersecting_days * price.price
      end
    end
    total_bill
  end

  def dates_conflict?
    room.bookings.where(status: :confirmed).any? do |booking|
      (start_date..end_date).overlaps?(booking.start_date..booking.end_date)
    end
  end

  def too_many_guests?
    number_of_guests > room.max_guests
  end
end
