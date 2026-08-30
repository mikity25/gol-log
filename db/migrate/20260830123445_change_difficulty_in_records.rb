class ChangeDifficultyInRecords < ActiveRecord::Migration[8.1]
  def change
    change_column :records, :difficulty, :string, default: nil
  end
end
