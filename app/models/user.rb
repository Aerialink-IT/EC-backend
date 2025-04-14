class User < ApplicationRecord
  has_secure_password

  has_many :orders, dependent: :destroy
  has_many :payment_transactions, through: :orders
  has_many :reviews, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :comment_reactions, dependent: :destroy
  has_many :loyalty_transactions, dependent: :destroy
  has_many :user_payment_methods, dependent: :destroy
  has_many :virtual_rooms, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_one_attached :profile_image
  has_one :cart, dependent: :destroy
  has_many :cart_items, through: :cart
  has_many :billing_details, dependent: :destroy
  has_many :user_sessions, dependent: :destroy
  has_many :coupon_usage_histories, dependent: :destroy

  has_one :reward_point, dependent: :destroy
  has_many :tiers_points, dependent: :destroy
  has_many :point_histories, dependent: :destroy
  has_many :delivery_addresses, dependent: :destroy
  has_many :inquiry_forms, dependent: :destroy
  has_one :chat, dependent: :destroy
  has_many :free_samples_requests, dependent: :destroy

  scope :with_profile_image, -> { joins(:profile_image_attachment).distinct }

  validates :username, uniqueness: true, presence: true, unless: -> { guest_user? }
  validates :password, presence: true, on: :create, unless: -> { guest_user? }
  validates :first_name, :last_name, presence: true, unless: -> { guest_user? }
  validates :phone, presence: true, format: { with: /\A[0-9]{7,15}\z/, message: 'must be 7 to 15 digits long' }, unless: -> { guest_user? }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'must be a valid email address' }, unless: -> { guest_user? }
  validates :session_id, uniqueness: true, allow_nil: true

  after_create :initialize_reward_and_tier
  before_validation :generate_username, on: :create

  def guest_user?
    guest_user
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

  def initialize_reward_and_tier
    RewardPoint.create(user: self, reward_points: 0, total_save: 0)
    TiersPoint.tier_types.keys.each do |tier_type|
      if tier_type == "basic"
        TiersPoint.create(user: self, tier_type: tier_type, tier_valid_from: Date.today, tier_valid_until: 1.year.from_now, status: true)
      else
        TiersPoint.create(user: self, tier_type: tier_type, status: false)
      end
    end
  end

  def generate_username
    base_username = "#{last_name}_#{first_name}".gsub(/\s+/, "").downcase
    self.username = unique_username(base_username)
  end

  def unique_username(base_username)
    username = base_username
    count = 1

    while User.exists?(username: username)
      username = "#{base_username}#{count}"
      count += 1
    end

    username
  end

  def self.find_or_create_guest(session_id)
    begin
      find_or_create_by!(session_id: session_id) do |user|
        user.first_name = "guest"
        user.last_name = "user"
        user.password = SecureRandom.hex(10)
        user.email = "guest_#{session_id}@guest.com"
        user.guest_user = true
      end
    rescue ActiveRecord::RecordNotUnique
      retry
    end
  end

  def self.ransackable_scopes(auth_object = nil)
    super + [:with_profile_image]
  end

  def self.ransackable_associations(auth_object = nil)
    ["loyalty_transactions", "orders", "reviews", "user_payment_methods", "virtual_rooms"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "first_name", "id", "id_value", "is_active", "last_name", "password_digest", "password_hash", "phone", "refresh_token", "reset_password_sent_at", "reset_password_token", "updated_at"]
  end

end
