class Address < ApplicationRecord
  validates :street,
            :neighborhood,
            :city,
            :state,
            :postal_code,
            presence: true

  belongs_to :inn
end
