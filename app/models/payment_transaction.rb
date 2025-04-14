class PaymentTransaction < ApplicationRecord
  belongs_to :order
  belongs_to :user_payment_method

  def self.ransackable_associations(auth_object = nil)
    ["order", "user_payment_method"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["amount", "created_at", "id", "id_value", "order_id", "status", "updated_at", "user_payment_method_id", "transaction_id", "payment_gateway", "currency", "payment_type", "payment_details", "gateway_status", "amount_refunded"]
  end
end
