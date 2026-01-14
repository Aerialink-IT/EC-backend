# This file should ensure all seed data is loaded
# Run with: rails db:seed

# Create default admin user if it doesn't exist
puts "\nCreating Admin User..."
admin_email = 'admin@example.com'
admin_password = 'password'

admin = AdminUser.find_or_create_by(email: admin_email) do |user|
  user.password = admin_password
  user.password_confirmation = admin_password
end

if admin.persisted?
  puts "✓ Admin user already exists or created: #{admin_email}"
else
  puts "❌ Failed to create admin user: #{admin.errors.full_messages.join(', ')}"
end

# Load content seeds
load Rails.root.join('db', 'seeds', 'content_seeds.rb')

puts "\n✓ All seeds completed successfully!"
