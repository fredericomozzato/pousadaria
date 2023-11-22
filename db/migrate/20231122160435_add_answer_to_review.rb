class AddAnswerToReview < ActiveRecord::Migration[7.0]
  def change
    add_column :reviews, :answer, :string
  end
end
