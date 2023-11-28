class Room < ApplicationRecord
  belongs_to :inn
  has_many :seasonal_prices
  has_many :bookings
  has_many_attached :photos

  validates :name,
            :size,
            :max_guests,
            :price,
            presence: true
  validates :size,
            :max_guests,
            :price,
            numericality: { greater_than: 0 }
  validates :photos, content_type: {
    in: ["image/jpg", "image/jpeg", "image/png"],
    message: "somente nos formatos JPG, JPEG ou PNG"
  }
  validates :photos, size: { less_than: 5.megabytes, message: "não pode ser maior que 5 mb" }
  validate -> { max_number_of_photos(5) }
end
