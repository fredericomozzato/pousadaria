class AddUniqueContraintToBookingCode < ActiveRecord::Migration[7.0]
  def change
    add_index :bookings, :code, unique: true
  end
end
