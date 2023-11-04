class SeasonalPrice < ApplicationRecord
  belongs_to :room
  validate :start_date_before_end_date, :end_date_is_past

  def date_pretty_print
    formatter = "%d/%m/%Y"
    "#{self.start.strftime(formatter)} - #{self.end.strftime(formatter)}"
  end

  private

  def start_date_before_end_date
    if self.start >= self.end
      errors.add :start, "Data de início não pode ser antes da data de término"
    end
  end

  def end_date_is_past
    if self.end < Date.today
      errors.add :end, "Data de término não pode estar no passado"
    end
  end

end
