class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :street
      t.integer :number
      t.string :neighborhood
      t.string :city
      t.string :state
      t.string :postal_code

      t.timestamps
    end
  end
end
