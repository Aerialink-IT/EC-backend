class AddCouponDetailsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :coupon_amount, :integer
    add_column :orders, :coupon_code, :string
  end
end
