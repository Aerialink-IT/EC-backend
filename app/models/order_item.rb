class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  before_save :set_total_price
  def self.ransackable_associations(auth_object = nil)
    ["order", "product"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "order_id", "size", "total_price", "product_id", "quantity", "unit_price", "updated_at"]
  end

  def set_total_price
    self.total_price = self.quantity.to_i*self.unit_price
  end
end
