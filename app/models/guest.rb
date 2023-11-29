class Guest < ApplicationRecord
  has_many :bookings, through: :booking_guests
end
