class Booking < ApplicationRecord
  belongs_to :room
  belongs_to :user

  def calculate_bill
    room = Room.find(room_id)
    (end_date - start_date).to_i * room.price
  end

  def dates_conflict?

  end

  def too_many_guests?

  end
end
