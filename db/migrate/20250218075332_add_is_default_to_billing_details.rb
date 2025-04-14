class AddIsDefaultToBillingDetails < ActiveRecord::Migration[7.1]
  def change
    add_column :billing_details, :is_default, :boolean, default: false
  end
end
