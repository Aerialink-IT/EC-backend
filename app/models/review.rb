class Review < ApplicationRecord
  belongs_to :user
  belongs_to :product
  has_many_attached :images, dependent: :destroy

  validates :rating, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "id_value", "product_id", "rating", "updated_at", "user_id"]
  end
end
