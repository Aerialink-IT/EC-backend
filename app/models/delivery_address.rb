class DeliveryAddress < ApplicationRecord
  belongs_to :user
  has_many :orders, dependent: :nullify

  has_many :free_samples_requests, dependent: :destroy

  validates :first_name, :last_name, :line1, :prefecture, :post_code, :phone_number, presence: true
end
