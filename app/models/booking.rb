class Booking < ApplicationRecord
  belongs_to :room
  belongs_to :user, optional: true

  validates :start_date, :end_date, :number_of_guests, presence: true

  validate :date_conflict, :too_many_guests

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

  private

  def count_intersecting_days(booking_range, price_range)
    days = ([booking_range.begin, price_range.begin].max...[booking_range.end, price_range.end].min).count
    return days += 1 if booking_range.count > price_range.count
    days
  end

  def date_conflict
    return if start_date.nil? || end_date.nil?

    conflict =  room.bookings.where(status: :confirmed).any? do |booking|
      (start_date..end_date).overlaps?(booking.start_date..booking.end_date)
    end

    errors.add(:start_date, I18n.t("date_conflict")) if conflict
  end

  def too_many_guests
    return if number_of_guests.nil?

    errors.add(:number_of_guests, I18n.t("too_many_guests")) if number_of_guests > room.max_guests
  end
end
