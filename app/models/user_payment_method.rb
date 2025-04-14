class UserPaymentMethod < ApplicationRecord
  belongs_to :user
  has_many :payment_transactions, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "is_default", "payment_details", "payment_type", "updated_at", "user_id"]
  end
end
