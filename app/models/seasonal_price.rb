class SeasonalPrice < ApplicationRecord
  belongs_to :room
  validates :start, :end, :price, presence: true
  validates :price, numericality: { greater_than: 0 }
  validate :end_date_is_past, :date_conflict, :start_date_before_end_date, :start_equals_to_end

  def date_pretty_print
    formatter = "%d/%m/%Y"
    "#{self.start.strftime(formatter)} - #{self.end.strftime(formatter)}"
  end

  private

  def start_date_before_end_date
    return if self.start.nil? || self.end.nil?

    if self.start > self.end
      errors.add :start, "Data de início não pode ser antes da data de término"
    end
  end

  def end_date_is_past
    return if self.end.nil?

    error_message = "Data de término não pode estar no passado"
    errors.add :end, error_message if self.end < Date.today
  end

  def date_conflict
    return if self.start.nil? || self.end.nil?

    if self.id.nil?
      room_seasonal_prices = SeasonalPrice.where("room_id = ?", self.room_id)
    else
      room_seasonal_prices = SeasonalPrice.where("room_id = ? AND id != ?", self.room_id, self.id)
    end

    room_seasonal_prices.each do |room|
      return if self.start.nil? || self.end.nil?

      start_error_msg = "Data de início conflita com outro preço sazonal"
      end_error_msg = "Data de término conflita com outro preço sazonal"

      errors.add :start, start_error_msg if (room.start..room.end).cover? self.start
      errors.add :end, end_error_msg if (room.start..room.end).cover? self.end
    end
  end

  def start_equals_to_end
    return if self.start.nil? || self.end.nil?

    error_message = "Data de início não pode ser igual à data de término"
    errors.add :start, error_message if self.start == self.end
  end
end
