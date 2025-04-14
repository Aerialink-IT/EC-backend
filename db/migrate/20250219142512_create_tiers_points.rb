class CreateTiersPoints < ActiveRecord::Migration[7.1]
  def change
    create_table :tiers_points do |t|
      t.references :user, null: false, foreign_key: true
      t.string :tier_type
      t.boolean :status
      t.integer :tier_point, default: 0
      t.datetime :tier_valid_from
      t.datetime :tier_valid_until

      t.timestamps
    end
  end
end
