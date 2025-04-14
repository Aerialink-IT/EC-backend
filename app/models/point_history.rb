class PointHistory < ApplicationRecord
  belongs_to :user
  belongs_to :reward_point
  belongs_to :tiers_point, optional: true
  belongs_to :order, optional: true

  validates :transaction_type, presence: true
  validates :points_earned, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :points_used, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  enum transaction_type: { 
    credit: "credit", 
    debit: "debit" 
  }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "order_id", "points_earned", "points_used", "reward_point_id", "tiers_point_id", "transaction_type", "updated_at", "user_id"]
  end
end
