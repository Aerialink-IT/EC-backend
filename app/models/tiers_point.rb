class TiersPoint < ApplicationRecord
  belongs_to :user
  has_many :point_histories, dependent: :destroy

  validates :tier_type, presence: true
  validates :tier_point, numericality: { greater_than_or_equal_to: 0 }

  enum tier_type: { 
    basic: "basic", 
    silver: "silver", 
    gold: "gold", 
    platinum: "platinum" 
  }

  scope :active, -> { where(status: true) }

  def check_tier_upgrade(user)
    current_tier = user.tiers_points.last.tier_type
    total_tier_points = user.tiers_points.active.sum(:tier_point)
  
    if total_tier_points >= 5000 && current_tier != "platinum"
      update_new_tier(user, "platinum")
    elsif total_tier_points >= 2500 && current_tier != "gold"
      update_new_tier(user, "gold")
    elsif total_tier_points >= 1000 && current_tier != "silver"
      update_new_tier(user, "silver")
    end
  end

  def check_tier_expiry(user)
    user_active_tiers = user.tiers_points.active
    return if user_active_tiers.blank?
    expired_tiers = user_active_tiers.where("tier_valid_until < ?", Date.today)
    return if expired_tiers.blank?
    if expired_tiers.exists?
      expired_tiers.each do |expired_tier|
        if expired_tier.tier_type == "basic"
          if user_active_tiers.count >= 2
            expired_tier.update(tier_point: 0, tier_valid_from: nil, tier_valid_until: nil, status: false)
          else
            expired_tier.update(tier_point: 0, tier_valid_from: Date.today, tier_valid_until: 1.year.from_now, status: true)
          end
        else
          total_points = expired_tier.tier_point
          new_tier = check_new_tier(total_points)
          expired_tier.update(tier_point: 0, tier_valid_from: nil, tier_valid_until: nil, status: false)
          update_new_tier(user, new_tier)
        end
      end
    end
  end

  def check_new_tier(total_points)
    new_tier = if total_points < 1000
                      "basic"
                    elsif total_points < 2500
                      "silver"
                    elsif total_points < 5000
                      "gold"
                    else
                      "platinum"
                    end
                    
  end
  

  def update_new_tier(user, new_tier)
    tier = user.tiers_points.where(tier_type: new_tier)
    tier.update(tier_point: 0, tier_valid_from: Date.today, tier_valid_until: 1.year.from_now, status: true)
  end
end
