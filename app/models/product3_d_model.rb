class Product3DModel < ApplicationRecord
  belongs_to :product

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "format", "id", "id_value", "model_url", "product_id", "updated_at", "uploaded_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["product"]
  end

end
