class AddUniqueConstraintsToInns < ActiveRecord::Migration[7.0]
  def change
    add_index :inns, :registration_number, unique: true
    add_index :inns, :corporate_name, unique: true
    add_index :inns, :email, unique: true
  end
end
