class ProductSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :uuid, :name, :description, :instructions, :colors, :sizes, :weight, :stock_quantity, :price, :is_active, :product_size, :created_at, :updated_at, :virtual_image, :images, :average_rating, :total_reviews, :is_in_wishlist, :is_in_cart
  has_many :description_images, serializer: DescriptionImageSerializer

  has_many :product_sizes, serializer: ProductSizeSerializer

  def images
    return [] unless object.images.attached?
    
    # Set url_options for ActiveStorage
    host_env = ENV["HOST"] || "localhost:3000"
    # Remove protocol if present
    host = host_env.gsub(/^https?:\/\//, '')
    protocol = Rails.env.production? ? "https" : "http"
    ActiveStorage::Current.url_options = { host: host, protocol: protocol }
    
    object.images.map do |image|
      url_for(image)
    rescue => e
      Rails.logger.error "Error generating image URL: #{e.message}"
      nil
    end.compact
  end

  def virtual_image
    return nil unless object.virtual_image.attached?
    
    # Use ActiveStorage::Current.url_options if already set (by ApplicationController)
    # Otherwise, set it based on available context
    unless ActiveStorage::Current.url_options.present?
      if scope.respond_to?(:request) && scope.request.present?
        host = scope.request.host_with_port
        host = host.gsub(/^https?:\/\//, '') # Remove protocol if present
        protocol = scope.request.protocol.gsub('://', '')
      else
        host_env = ENV["HOST"] || "localhost:3000"
        host = host_env.gsub(/^https?:\/\//, '') # Remove protocol if present
        protocol = Rails.env.production? ? "https" : "http"
      end
      ActiveStorage::Current.url_options = { host: host, protocol: protocol }
    end
    
    url_for(object.virtual_image)
  rescue => e
    Rails.logger.error "Error generating virtual_image URL: #{e.message}"
    nil
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
