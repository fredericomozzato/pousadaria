class AddCustomFieldsToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :name, :string, null: false, default: ""
    add_column :users, :cpf, :string, null: false, default: ""
  end
end
