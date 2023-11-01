class AddOwnerReferenceToInn < ActiveRecord::Migration[7.0]
  def change
    add_reference :inns, :owner, null: false, foreign_key: true
  end
end
