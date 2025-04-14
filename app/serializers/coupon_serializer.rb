class CouponSerializer < ActiveModel::Serializer
  attributes :id, :code, :name, :discount_type, :discount_value, :user_id, :status, :coupon_type, :valid_from, :valid_until, :created_at, :updated_at
end
