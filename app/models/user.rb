class User < ApplicationRecord
  validates :name, :cpf, presence: true
  validates :cpf, uniqueness: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

end
