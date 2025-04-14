class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.references :product, foreign_key: true
      t.string :code
      t.string :name
      t.decimal :discount
      t.integer :status
      t.integer :coupon_type
      t.date :valid_from
      t.date :valid_until

      t.timestamps
    end
  end
end
