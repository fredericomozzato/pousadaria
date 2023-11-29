class CreateBookingGuests < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_guests do |t|
      t.references :booking, null: false, foreign_key: true
      t.references :guest, null: false, foreign_key: true

      t.timestamps
    end
  end
end
