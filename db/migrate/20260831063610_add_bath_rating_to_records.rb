class AddBathRatingToRecords < ActiveRecord::Migration[8.1]
  def change
    add_column :records, :bath_rating, :string
  end
end
