class AddDefaultActiveRooms < ActiveRecord::Migration[7.0]
  def change
    change_column_default :rooms, :active, true
  end
end
