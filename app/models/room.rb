class Room < ApplicationRecord
  belongs_to :inn
  has_many :seasonal_prices
  has_many :bookings

  validates :name,
            :size,
            :max_guests,
            :price,
            presence: true
  validates :size,
            :max_guests,
            :price,
            numericality: { greater_than: 0 }
end
