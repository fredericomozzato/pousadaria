class CreateRooms < ActiveRecord::Migration[7.0]
  def change
    create_table :rooms do |t|
      t.string :name
      t.string :description
      t.integer :size
      t.integer :max_guests
      t.decimal :price
      t.boolean :bathroom
      t.boolean :porch
      t.boolean :air_conditioner
      t.boolean :tv
      t.boolean :wardrobe
      t.boolean :safe
      t.boolean :wifi
      t.boolean :accessibility
      t.references :inn, null: false, foreign_key: true
      t.boolean :active

      t.timestamps
    end
  end
end
