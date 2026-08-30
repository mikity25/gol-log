class AddDetailsToRecords < ActiveRecord::Migration[8.1]
  def change
    add_column :records, :tee, :string
    add_column :records, :pace, :string
    add_column :records, :play_style, :string
    add_column :records, :brand, :string
    add_column :records, :course_width, :string
    add_column :records, :fairway, :string
    add_column :records, :green_features, :string
    add_column :records, :green_memo, :string
    add_column :records, :ob_risk, :string
    add_column :records, :bunker_difficulty, :string
    add_column :records, :hazard, :string
    add_column :records, :toilet_rating, :string
    add_column :records, :driving_range, :string
    add_column :records, :bath_features, :string
    add_column :records, :bath_memo, :string
    add_column :records, :shop_memo, :string
    add_column :records, :cart_type, :string
    add_column :records, :maintenance, :string
    add_column :records, :service, :string
    add_column :records, :food_rating, :string
    add_column :records, :food_memo, :text
    add_column :records, :plan_options, :string
    add_column :records, :total_cost, :integer
    add_column :records, :cost_memo, :string
  end
end
