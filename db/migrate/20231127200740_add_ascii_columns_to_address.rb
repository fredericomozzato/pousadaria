class AddAsciiColumnsToAddress < ActiveRecord::Migration[7.0]
  def change
    add_column :addresses, :street_ascii, :string
    add_column :addresses, :neighborhood_ascii, :string
    add_column :addresses, :city_ascii, :string
  end
end
