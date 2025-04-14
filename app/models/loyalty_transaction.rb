class LoyaltyTransaction < ApplicationRecord
  belongs_to :user

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "points", "transaction_type", "updated_at", "user_id"]
  end
end
