class AddFieldsToPaymentTransactions < ActiveRecord::Migration[7.1]
  def change
    add_column :payment_transactions, :transaction_id, :string
    add_column :payment_transactions, :payment_gateway, :string
    add_column :payment_transactions, :currency, :string
    add_column :payment_transactions, :payment_type, :string
    add_column :payment_transactions, :payment_details, :text
    add_column :payment_transactions, :gateway_status, :string
    add_column :payment_transactions, :captured_at, :datetime
    add_column :payment_transactions, :amount_refunded, :decimal
  end
end
