class CreateRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :records do |t|
      t.references :user, null: false, foreign_key: true
      t.string :golf_course_name, null: false
      t.date :played_on, null: false
      t.integer :satisfaction, null: false
      t.integer :difficulty
      t.integer :food
      t.integer :facility
      t.integer :score_18h
      t.integer :score_9h
      t.integer :converted_score_18h
      t.text :memo

      t.timestamps
    end
  end
end