class Booking < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validate :dates_conflict?

  enum status: {confirmed: 0, active: 5, closed: 10, canceled: 15}

  def calculate_bill
    room = Room.find(room_id)
    booking_range = start_date...end_date
    total_bill = booking_range.count * room.price

    room.seasonal_prices.each do |price|
      price_range = price.start..price.end
      if booking_range.overlaps? price_range
        total_bill += count_intersecting_days(booking_range, price_range) * (price.price - room.price)
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

  private

  def count_intersecting_days(booking_range, price_range)
    days = ([booking_range.begin, price_range.begin].max...[booking_range.end, price_range.end].min).count
    return days += 1 if booking_range.count > price_range.count
    days
  end
end
