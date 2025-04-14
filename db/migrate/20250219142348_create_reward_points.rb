class CreateRewardPoints < ActiveRecord::Migration[7.1]
  def change
    create_table :reward_points do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :reward_points, default: 0
      t.integer :total_save, default: 0

      t.timestamps
    end
  end
end
