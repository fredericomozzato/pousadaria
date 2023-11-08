class AddNotNullConstraintsToInn < ActiveRecord::Migration[7.0]
  def change
    change_column_null :inns, :name, false
    change_column_null :inns, :corporate_name, false
    change_column_null :inns, :registration_number, false
    change_column_null :inns, :phone, false
    change_column_null :inns, :email, false
    change_column_null :inns, :pay_methods, false
  end
end
