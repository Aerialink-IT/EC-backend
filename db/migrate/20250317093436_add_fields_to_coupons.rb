class AddFieldsToCoupons < ActiveRecord::Migration[7.1]
  def up
    remove_reference :coupons, :product, index: true, foreign_key: true
    add_reference :coupons, :user, index: true, foreign_key: true
    rename_column :coupons, :discount, :discount_value
    add_column :coupons, :discount_type, :integer
  end

  def down
    remove_reference :coupons, :user, index: true, foreign_key: true
    add_reference :coupons, :product, index: true, foreign_key: true
    rename_column :coupons, :discount_value, :discount
    remove_column :coupons, :discount_type
  end
end
