class ChangeAddressNumberToString < ActiveRecord::Migration[7.0]
  def change
    change_column :addresses, :number, :string
  end
end
