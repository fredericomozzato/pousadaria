class SetNotNullAttributesRooms < ActiveRecord::Migration[7.0]
  def change
    change_column_null :rooms, :name, false
    change_column_null :rooms, :size, false
    change_column_null :rooms, :max_guests, false
    change_column_null :rooms, :price, false
  end
end
