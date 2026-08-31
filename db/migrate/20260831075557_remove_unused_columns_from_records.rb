class RemoveUnusedColumnsFromRecords < ActiveRecord::Migration[8.1]
  def change
    remove_column :records, :facility, :integer
    remove_column :records, :food, :integer
  end
end
