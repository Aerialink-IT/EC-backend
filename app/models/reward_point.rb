class RewardPoint < ApplicationRecord
  belongs_to :user
  has_many :point_histories, dependent: :destroy

  validates :reward_points, numericality: { greater_than_or_equal_to: 0 }
  validates :total_save, numericality: { greater_than_or_equal_to: 0 }

  def add_points(user, purchase_amount, order_id)
    points = calculate_points(user, purchase_amount)
    
    user.reward_point.increment!(:reward_points, points)

    user_active_tier = user.tiers_points.active.last
    user_active_tier.increment!(:tier_point, points)
    user.point_histories.create!(
      points_earned: points,
      transaction_type: :credit,
      reward_point_id: user.reward_point.id,
      tiers_point_id: user_active_tier.id,
      order_id: order_id
    )
    user_active_tier.check_tier_upgrade(user)
  end

  def use_points_for_order(order_id)
    order = Order.find_by(id: order_id)
    return unless order.present? && order.reward_points_used.present?

    used_points = order.reward_points_used
    user = order.user
    reward_point = user.reward_point
    active_tier = user.tiers_points.active.last
    reward_point.update!(
      reward_points: reward_point.reward_points.to_i - used_points,
      total_save: reward_point.total_save.to_i + used_points
    )

    user.point_histories.create!(
      points_used: used_points,
      transaction_type: :debit,
      reward_point_id: reward_point.id,
      tiers_point_id: active_tier.id,
      order_id: order_id
    )
  end

  def calculate_points(user, purchase_amount)
    tier = user.tiers_points.active.last.tier_type
    percentage = case tier
                when "basic" then 0.01
                when "silver" then 0.012
                when "gold" then 0.0135
                when "platinum" then 0.015
                else 0
                end
    (purchase_amount * percentage).to_i
  end
end
