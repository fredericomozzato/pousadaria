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
    self.room.bookings.where(status: :confirmed).any? do |booking|
      (self.start_date..self.end_date).overlaps?(booking.start_date..booking.end_date)
    end
  end

  def too_many_guests?

  end
end
