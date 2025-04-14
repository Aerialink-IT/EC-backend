class AddSessionIdToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :session_id, :string
  end
end
