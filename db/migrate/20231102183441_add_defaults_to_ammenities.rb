class AddDefaultsToAmmenities < ActiveRecord::Migration[7.0]
  def change
    change_column_default :rooms, :bathroom, false
    change_column_default :rooms, :porch, false
    change_column_default :rooms, :air_conditioner, false
    change_column_default :rooms, :tv, false
    change_column_default :rooms, :wardrobe, false
    change_column_default :rooms, :safe, false
    change_column_default :rooms, :wifi, false
    change_column_default :rooms, :accessibility, false
  end
end
