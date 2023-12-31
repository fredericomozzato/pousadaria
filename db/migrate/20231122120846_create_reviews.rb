class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.integer :score, null: false
      t.string :message
      t.references :booking, null: false, foreign_key: true

      t.timestamps
    end
  end
end
