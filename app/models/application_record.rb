class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  protected

  def max_number_of_photos(limit)
    return unless self.photos.attached?

    errors.add(:photos, "Número máximo de fotos: #{limit}") if photos.count > limit
  end
end
