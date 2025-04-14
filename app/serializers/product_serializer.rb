class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :uuid, :name, :description, :instructions, :colors, :sizes, :weight, :stock_quantity, :price, :is_active, :product_size, :created_at, :updated_at, :virtual_image, :images, :average_rating, :total_reviews, :is_in_wishlist, :is_in_cart
  has_many :description_images, serializer: DescriptionImageSerializer

  has_many :product_sizes, serializer: ProductSizeSerializer

  def images
    object.images.map { |image| image.url }
  end

  def virtual_image
    object.virtual_image.url
  end

  def average_rating
    object.reviews.average(:rating)&.round(1) || 0.0
  end

  def total_reviews
    object.reviews.count
  end

  def is_in_wishlist
    return false unless scope.present?
    object.wishlists.exists?(user: scope)
  end

  def is_in_cart
    return false unless scope.present?
    object.cart_items.exists?(cart: scope.cart)
  end
end
