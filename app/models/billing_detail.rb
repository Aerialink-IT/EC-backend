class BillingDetail < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :destroy

  validates :full_name, :phone_number, :street_address, :postal_code, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "full_name", "id", "id_value", "is_default", "phone_number", "postal_code", "street_address", "updated_at", "user_id"]
  end
end