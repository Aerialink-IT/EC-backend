class CouponsController < ApplicationController
  def index
    seasonal_coupons = Coupon.seasonal.active
    member_coupons = Coupon.member_specific.active.where(user: current_user)
    coupons = Coupon.where(id: seasonal_coupons.select(:id))
                    .or(Coupon.where(id: member_coupons.select(:id)))
    coupons = paginate(coupons)

    render json: {
      coupons: ActiveModelSerializers::SerializableResource.new(coupons, each_serializer: CouponSerializer),
      reward_point: current_user&.reward_point,
      active_tier: current_user&.tiers_points&.active&.last,
      meta: pagination_meta(coupons)
    }
  end
end
