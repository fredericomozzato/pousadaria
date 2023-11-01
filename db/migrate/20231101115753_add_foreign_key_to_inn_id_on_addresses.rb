class AddForeignKeyToInnIdOnAddresses < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :addresses, :inns, column: :inn_id
  end
end
