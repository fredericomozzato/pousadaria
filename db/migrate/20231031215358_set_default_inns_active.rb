class SetDefaultInnsActive < ActiveRecord::Migration[7.0]
  def change
    change_column :inns, :active, :boolean, default: true
  end
end
