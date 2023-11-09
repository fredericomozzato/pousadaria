class Inn < ApplicationRecord
  has_one :address
  belongs_to :owner
  has_many :rooms

  accepts_nested_attributes_for :address

  validates :name,
            :corporate_name,
            :registration_number,
            :phone,
            :email,
            :pay_methods,
            presence: true

  def get_street_values
    "#{address.street}, #{address.number}"
  end

  def get_location_values
    "#{address.neighborhood} - #{address.city}, #{address.state}"
  end
end
