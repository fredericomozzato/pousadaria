class Booking < ApplicationRecord
  belongs_to :room
  belongs_to :user, optional: true
  has_one :review
  has_many :booking_guests
  has_many :guests, through: :booking_guests

  validates :start_date, :end_date, :number_of_guests, presence: true
  validates :number_of_guests, numericality: {greater_than: 0}
  validates :code, uniqueness: true

  validate :past_dates, :date_conflict, :too_many_guests, :active_room, on: :create

  before_validation :generate_code, on: :create

  enum status: {confirmed: 0, active: 10, closed: 20, canceled: 30}

  def cancel_date
    start_date - 7.days
  end

  def calculate_bill
    return get_booking_range.reduce(0) do |bill, date|
      if room.seasonal_prices.any? { |price| date.between?(price.start, price.end) }
        room.seasonal_prices.each do |price|
          bill += price.price if date.between?(price.start, price.end)
        end
      else
        bill += room.price
      end
      bill
    end
  end

  private

  def get_booking_range
    return checkout_range if check_out
    start_date...end_date
  end

  def checkout_range
    limit = room.inn.check_out_time
    if check_out.hour >= limit.hour || (check_out.hour == limit.hour) && check_out.min >= limit.min
      start_date..check_out.to_date
    else
      start_date...check_out.to_date
    end
  end

  def date_conflict
    return if start_date.nil? || end_date.nil?

    conflict = room.bookings
                   .where(status: [:confirmed, :active])
                   .where.not(id: self.id)
                   .any? do |booking|
      (start_date..end_date).overlaps?(booking.start_date..booking.end_date)
    end

    errors.add(:date_conflict, I18n.t("date_conflict")) if conflict
  end

  def too_many_guests
    return if number_of_guests.nil?

    errors.add(:number_of_guests, I18n.t("too_many_guests")) if number_of_guests > room.max_guests
  end

  def past_dates
    return if start_date.nil? || end_date.nil?

    errors.add(:start_date, I18n.t("cant_be_past")) if start_date < Date.today
    errors.add(:end_date, I18n.t("cant_be_past")) if end_date < Date.today
    errors.add(:end_date, I18n.t("cant_be_before_checkin")) if end_date < start_date
  end

  def active_room
    room = Room.find_by(id: room_id)

    errors.add(:room, I18n.t("room_unavailable")) unless room&.active?
  end

  def generate_code
    self.code ||= SecureRandom.alphanumeric(8).upcase
  end
end
