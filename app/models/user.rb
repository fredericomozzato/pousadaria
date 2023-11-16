class User < ApplicationRecord
  has_many :bookings

  validates :name, :cpf, presence: true
  validates :cpf, uniqueness: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

end
