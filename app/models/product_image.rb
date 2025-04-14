class ProductImage < ApplicationRecord
  belongs_to :product

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "id_value", "image_url", "is_primary", "product_id", "updated_at", "uploaded_at"]
  end
end
