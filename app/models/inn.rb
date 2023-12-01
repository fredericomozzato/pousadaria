class Inn < ApplicationRecord
  has_one :address
  belongs_to :owner
  has_many :rooms
  has_many :bookings, through: :rooms
  has_many :reviews, through: :bookings
  has_many_attached :photos

  accepts_nested_attributes_for :address

  validates :name,
            :corporate_name,
            :registration_number,
            :phone,
            :email,
            :pay_methods,
            presence: true
  validates :photos, content_type: {
    in: ["image/jpg", "image/jpeg", "image/png"],
    message: "somente nos formatos JPG, JPEG ou PNG"
  }
  validates :photos, size: { less_than: 5.megabytes, message: "não pode ser maior que 5 mb" }
  validate :validates_registration_number
  validate -> { max_number_of_photos(5) }

  def self.search_inns(query)
    Inn.joins(:address)
       .where(active: true)
       .where("name LIKE :query OR city LIKE :query OR neighborhood LIKE :query",
               query: "%#{query}%")
       .order(:name)
  end

  def self.advanced_search(params)
    @inns = Inn.joins(:address, :rooms).where(active: true)
    @inns = @inns.where("inns.name LIKE ?", "%#{params[:name]}%") if params[:name].present?
    @inns = @inns.where("addresses.city LIKE ?", "%#{params[:city]}%") if params[:city].present?
    @inns = @inns.where(inns: { pet_friendly: true }) if params[:pet_friendly] == "1"

    room_params = self.room_params(params)

    @inns = @inns.where(rooms: room_params) if room_params.present?
    @inns.uniq
  end

  def self.all_cities
    Inn.joins(:address).where(active: true).pluck(:city).uniq.sort
  end

  def self.from_city(city)
    Inn.joins(:address)
       .where(active: true)
       .where("city_ascii LIKE ?", "%#{I18n.transliterate(city)}%")
  end

  def average_score
    bookings.joins(:review).average("score")&.round(1) || ""
  end

  def formatted_check_in_time
    check_in_time.strftime("%H:%M")
  end

  def formatted_check_out_time
    check_out_time.strftime("%H:%M")
  end

  private

  def validates_registration_number
    cnpj = BrDocuments::CnpjCpf::Cnpj.new(registration_number)
    errors.add(:registration_number, " inválido") unless cnpj.valid?
  end

  def self.room_params(params)
    room_params = {}
    room_params[:accessibility] = true if params[:accessibility] == "1"
    room_params[:wifi] = true if params[:wifi] == "1"
    room_params[:bathroom] = true if params[:bathroom] == "1"
    room_params[:air_conditioner] = true if params[:air_conditioner] == "1"
    room_params[:wardrobe] = true if params[:wardrobe] == "1"
    room_params[:tv] = true if params[:tv] == "1"
    room_params[:porch] = true if params[:porch] == "1"
    room_params[:safe] = true if params[:safe] == "1"
    room_params
  end
end
