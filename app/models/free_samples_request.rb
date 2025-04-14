class FreeSamplesRequest < ApplicationRecord
  belongs_to :user
  belongs_to :delivery_address

  has_many :free_sample_products, dependent: :destroy
  has_many :products, through: :free_sample_products

  validates :email, presence: true
  validate :maximum_six_products

  def maximum_six_products
    errors.add(:products, "You can select up to 6 products") if products.size > 6
  end

  def self.ransackable_attributes(auth_object = nil)
    ["id", "free_samples_request_id", "product_id", "created_at", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["free_samples_request", "product"]
  end
end
