class Address < ApplicationRecord
  belongs_to :inn

  validates :street,
            :number,
            :neighborhood,
            :city,
            :state,
            :postal_code,
            presence: true
  validates :number, numericality: { greater_than: 0 }
  validates :state, length: { is: 2}

  enum states: {
    AC: 1,
    AL: 2,
    AP: 3,
    AM: 4,
    BA: 5,
    CE: 6,
    DF: 7,
    ES: 8,
    GO: 9,
    MA: 10,
    MT: 11,
    MS: 12,
    MG: 13,
    PA: 14,
    PB: 15,
    PR: 16,
    PE: 17,
    PI: 18,
    RJ: 19,
    RN: 20,
    RS: 21,
    RO: 22,
    RR: 23,
    SC: 24,
    SP: 25,
    SE: 26,
    TO: 27
  }

  def street_values
    "#{street}, #{number}"
  end

  def location_values
    "#{neighborhood} - #{city}, #{state}"
  end
end
