class Room < ApplicationRecord
  validates :name,
            :size,
            :max_guests,
            :price,
            presence: true
  validates :size,
            :max_guests,
            numericality: { greater_than: 0 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }


  belongs_to :inn
end
