class Order < ApplicationRecord
  belongs_to :user
  belongs_to :billing_detail, optional: true
  belongs_to :delivery_address, optional: true
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  has_one :payment_transaction, dependent: :destroy
  has_many :point_histories, dependent: :destroy
  has_many :coupon_usage_histories, dependent: :destroy

  validates :status, presence: true
  validates :payment_status, presence: true
  accepts_nested_attributes_for :order_items, allow_destroy: true

  enum status: {
    created: "created",
    placed: "placed",
    confirmed: "confirmed",
    delivered: "delivered",
    cancelled: "cancelled"
  }

  enum payment_status: {
    pending: "pending",
    processing: "processing",
    paid: "paid",
    failed: "failed",
    refunded: "refunded",
    cod_pending: "cod_pending",
    cod_received: "cod_received"
  }

  enum payment_method: {
    komoju: "komoju",
    cash_on_delivery: "cash_on_delivery"
  }

  def self.ransackable_associations(auth_object = nil)
    ["order_items", "payment_transaction", "products", "user", "billing_detail", "point_histories"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "loyalty_points_used", "status", "total_amount", "updated_at", "user_id", "sub_total", "payment_method", "payment_status", "consumer_tax", "shipping", "delivery_fees", "session_id", "reward_points_used", "delivery_address_id", "coupon_usage_histories_id", "coupon_amount", "coupon_code"]
  end

  def total_price
    (order_items.sum(:total_price))
  end
end
