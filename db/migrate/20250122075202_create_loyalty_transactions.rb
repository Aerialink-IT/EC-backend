class CreateLoyaltyTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :loyalty_transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :points
      t.string :transaction_type
      t.string :description

      t.timestamps
    end
  end
end
