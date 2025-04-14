class AddBillingDetailsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :billing_detail, null: true, foreign_key: true
    add_column :orders, :sub_total, :decimal
    add_column :orders, :payment_method, :string
  end
end
