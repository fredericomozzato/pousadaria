class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.datetime :check_in
      t.datetime :check_out
      t.decimal :bill
      t.integer :status, null: false, default: 0
      t.integer :number_of_guests, null: false

      t.timestamps
    end
  end
end
