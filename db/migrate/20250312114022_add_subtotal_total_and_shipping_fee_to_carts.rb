class AddSubtotalTotalAndShippingFeeToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :subtotal, :decimal
    add_column :carts, :total, :decimal
    add_column :carts, :shipping_fee, :decimal
  end
end
