class AddWeatherToRecords < ActiveRecord::Migration[8.1]
  def change
    add_column :records, :weather, :string
  end
end
