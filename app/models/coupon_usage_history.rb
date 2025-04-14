class CouponUsageHistory < ApplicationRecord
  belongs_to :user
  belongs_to :coupon
  belongs_to :order

  validates :discount_value, numericality: { greater_than_or_equal_to: 0 }
  validates :coupon_code, presence: true
  validates :used_at, presence: true
end
