class ProductSize < ApplicationRecord
  belongs_to :product

  validates :size, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
