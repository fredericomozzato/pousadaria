class Room < ApplicationRecord
  validates :name,
            :size,
            :max_guests,
            :price,
            presence: true

  belongs_to :inn
end
