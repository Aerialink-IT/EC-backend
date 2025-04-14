class AddRewardPointsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :reward_points_used, :integer
  end
end
