class AddPayMethodToBooking < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :pay_method, :string
  end
end
