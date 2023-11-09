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

  def self.search_inns(query)
    Inn.joins(:address)
               .where(active: true)
               .where("name LIKE :query OR city LIKE :query OR neighborhood LIKE :query",
                      query: "%#{query}%")
               .order(:name)
  end
end
