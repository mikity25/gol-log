class AddCompanionToRecords < ActiveRecord::Migration[8.1]
  def change
    add_column :records, :companion, :string
  end
end
