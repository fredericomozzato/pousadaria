class Room < ApplicationRecord
  validates :name,
            :size,
            :max_guests,
            :price,
            presence: true
  validates :size,
            :max_guests,
            :price,
            numericality: { greater_than: 0 }

  belongs_to :inn

end
