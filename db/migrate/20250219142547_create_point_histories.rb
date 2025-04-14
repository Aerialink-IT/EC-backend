class CreatePointHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :point_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :reward_point, null: false, foreign_key: true
      t.references :tiers_point, foreign_key: true
      t.references :order, foreign_key: true
      t.string :transaction_type
      t.integer :points_earned, default: 0
      t.integer :points_used, default: 0
      t.string :description

      t.timestamps
    end
  end
end
