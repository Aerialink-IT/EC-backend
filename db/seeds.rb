# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# AdminUser.find_or_create_by!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# CSV.foreach("orders.csv", headers: true, col_sep: ",") do |row|
#   row_data = {
#     user_id: row["user_id"],
#     total_amount: row["total_amount"],
#     loyalty_points_used: row["loyalty_points_used"],
#     status: row["status"]
#   }
#   Order.create!(row_data)
# end

# User.all.each do |user|
#   unless user.username.present?
#     user.generate_username;
#     unless user.save
#       user.destroy
#     end
#   end
# end

if Rails.env.development?
  admin = AdminUser.find_by(email: 'admin@example.com')
  unless admin
    AdminUser.create!(
      email: 'admin@example.com',
      password: 'password',
      password_confirmation: 'password'
    )
  end
end

seasonal_coupons = [
  { name: "Start-New-Life Sale", code: "STARTNEWLIFE"},
  { name: "Summer Sale", code: "SUMMER" },
  { name: "Black Friday", code: "BLACKFRIDAY"},
  { name: "Holiday Sale", code: "HOLIDAY"}
]

seasonal_coupons.each do |coupon|
  existing_coupon = Coupon.find_by(code: coupon[:code])
  unless existing_coupon
    Coupon.create!(
      name: coupon[:name],
      code: coupon[:code],
      coupon_type: :seasonal,
      discount_type: :percentage,
      discount_value: 10,
      status: :inactive,
      valid_from: Date.today,
      valid_until: Date.today
    )
    puts "Created coupon: #{coupon[:name]}"
  else
    puts "Coupon already exists: #{coupon[:name]}"
  end
end

