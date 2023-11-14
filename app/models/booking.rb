class Booking < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validate :dates_conflict?

  enum status: {confirmed: 0, active: 5, closed: 10, canceled: 15}



  def calculate_bill
    room = Room.find(room_id)
    (end_date - start_date).to_i * room.price
  end

  def dates_conflict?
    room.bookings.where(status: :confirmed).any? do |booking|
      (start_date..end_date).overlaps?(booking.start_date..booking.end_date)
    end
  end

  def too_many_guests?
    room.max_guests <= number_of_guests
  end
end
