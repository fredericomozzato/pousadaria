class Owner < ApplicationRecord
  has_one :inn

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
