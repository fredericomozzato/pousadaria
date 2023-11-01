class Inn < ApplicationRecord
  validates :name,
            :corporate_name,
            :registration_number,
            :phone,
            :email,
            :pay_methods,
            presence: true

  has_one :address
  belongs_to :owner

  accepts_nested_attributes_for :address

  def get_street_values
    "#{address.street}, #{address.number}"
  end

  def get_location_values
    "#{address.neighborhood} - #{address.city}, #{address.state}"
  end
end
