class CreateInns < ActiveRecord::Migration[7.0]
  def change
    create_table :inns do |t|
      t.string :name
      t.string :corporate_name
      t.string :registration_number
      t.string :phone
      t.string :email
      t.references :address, null: false, foreign_key: true
      t.string :description
      t.string :pay_methods
      t.boolean :pet_friendly
      t.string :user_policies
      t.time :check_in_time
      t.time :check_out_time
      t.boolean :active

      t.timestamps
    end
  end
end
