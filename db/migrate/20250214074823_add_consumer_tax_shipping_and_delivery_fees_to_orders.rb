class AddConsumerTaxShippingAndDeliveryFeesToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :consumer_tax, :decimal
    add_column :orders, :shipping, :decimal
    add_column :orders, :delivery_fees, :decimal
  end
end
