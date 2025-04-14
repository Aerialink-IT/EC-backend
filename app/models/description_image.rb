class DescriptionImage < ApplicationRecord
  belongs_to :product
  has_one_attached :image
end
