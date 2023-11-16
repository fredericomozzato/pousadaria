class AddRandomCodeToBookings < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :code, :string
  end
end
