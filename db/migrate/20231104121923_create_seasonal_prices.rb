class CreateSeasonalPrices < ActiveRecord::Migration[7.0]
  def change
    create_table :seasonal_prices do |t|
      t.references :room, null: false, foreign_key: true
      t.date :start, null: false
      t.date :end, null: false
      t.decimal :price, precision: 10, scale: 2, null: false

      t.timestamps
    end
  end
end
