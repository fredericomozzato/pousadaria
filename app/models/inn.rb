class Inn < ApplicationRecord
  has_one :address
  belongs_to :owner

  accepts_nested_attributes_for :address
end
