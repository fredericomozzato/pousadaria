class AddInnReferenceToAddressTable < ActiveRecord::Migration[7.0]
  def change
    add_reference :addresses, :inn, foreign_key: true
  end
end
