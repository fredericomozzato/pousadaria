class User < ApplicationRecord
  has_many :bookings

  validates :name, :cpf, presence: true
  validates :cpf, uniqueness: true
  validate :validates_cpf


  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  private

  def validates_cpf
    cpf = BrDocuments::CnpjCpf::Cpf.new(self.cpf)
    errors.add(:cpf, " inválido") unless cpf.valid?
  end
end
