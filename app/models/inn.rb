class Inn < ApplicationRecord
  has_one :address
  belongs_to :owner
  has_many :rooms
  has_many :bookings, through: :rooms
  has_many :reviews, through: :bookings

  accepts_nested_attributes_for :address

  validates :name,
            :corporate_name,
            :registration_number,
            :phone,
            :email,
            :pay_methods,
            presence: true
  validate :validates_registration_number

  def self.search_inns(query)
    Inn.joins(:address)
       .where(active: true)
       .where("name LIKE :query OR city LIKE :query OR neighborhood LIKE :query",
               query: "%#{query}%")
       .order(:name)
  end

  def self.advanced_search(params)
    Inn.joins(:address, :rooms)
       .where("inns.name LIKE ?", "%#{params[:name]}%")
       .where("addresses.city LIKE ?", "%#{params[:city]}%")
       .where(inns: {
                active: true,
                pet_friendly: params[:pet_friendly]},
              rooms: {
                bathroom: params[:bathroom],
                porch: params[:porch],
                air_conditioner: params[:air_conditioner],
                tv: params[:tv],
                wardrobe: params[:wardrobe],
                safe: params[:safe],
                wifi: params[:wifi],
                accessibility: params[:accessibility]
              }).uniq
  end

  def average_score
    # return nil if bookings.empty?

    # scores = bookings.map { |booking| booking.review&.score }.compact

    # return nil if scores.empty?
    # scores.sum.to_f / scores.count

    bookings.joins(:review).average("score")
  end

  private

  def validates_registration_number
    cnpj = BrDocuments::CnpjCpf::Cnpj.new(registration_number)
    errors.add(:registration_number, " inválido") unless cnpj.valid?
  end
end
