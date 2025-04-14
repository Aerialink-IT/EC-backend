class CreateCouponUsageHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :coupon_usage_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :coupon, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.decimal :discount_value
      t.string :coupon_code
      t.datetime :used_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end
  end
end
