class AddDefaultToPetFriendly < ActiveRecord::Migration[7.0]
  def change
    change_column :inns, :pet_friendly, :boolean, default: false
  end
end
