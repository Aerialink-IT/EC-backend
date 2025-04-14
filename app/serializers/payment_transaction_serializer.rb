class PaymentTransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :status, :transaction_id, :payment_gateway, :currency, :payment_type, :payment_details, :gateway_status, :captured_at, :amount_refunded, :created_at, :updated_at, :order, :user_payment_method
end
