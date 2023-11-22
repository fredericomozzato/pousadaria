class Review < ApplicationRecord
  belongs_to :booking

  validates :score, presence: true

  enum scores: { "0" => 0, "1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5 }
end
