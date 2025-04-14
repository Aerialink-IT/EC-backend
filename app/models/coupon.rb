class Coupon < ApplicationRecord
  belongs_to :user, optional: true
  has_many :coupon_usage_histories, dependent: :destroy

  validates :code, uniqueness: true
  validates :name, :code, :coupon_type, :discount_type, :discount_value, :status, :valid_from, :valid_until, presence: true
  validates :user_id, presence: true, if: -> { coupon_type == 'member_specific' }

  enum status: { active: 0, inactive: 1, expired: 2 }
  enum coupon_type: { seasonal: 0, member_specific: 1 }
  enum discount_type: { percentage: 0, fixed: 1 }

  scope :active, -> { where(status: :active) }
  scope :seasonal, -> { where(coupon_type: :seasonal) }
  scope :member_specific, -> { where(coupon_type: :member_specific) }

  def self.ransackable_attributes(auth_object = nil)
    ["code", "coupon_type", "created_at", "discount_type", "discount_value", "id", "name", "user_id", "status", "updated_at", "valid_from", "valid_until"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end
end