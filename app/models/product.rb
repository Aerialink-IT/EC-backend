class Product < ApplicationRecord
  include PgSearch::Model

  has_many :order_items, dependent: :destroy
  has_many :orders, through: :order_items
  has_many :cart_items, dependent: :destroy
  has_many :cart, through: :cart_items
  has_many :product_categories, dependent: :destroy
  has_many :categories, through: :product_categories
  has_many :reviews, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :product_images, dependent: :destroy
  has_many :product3_d_models, dependent: :destroy
  has_many :virtual_room_items, dependent: :destroy
  has_many_attached :images, dependent: :destroy
  has_one_attached :virtual_image, dependent: :destroy
  has_many :wishlists, dependent: :destroy
  has_many :description_images, dependent: :destroy
  has_many :product_sizes, dependent: :destroy

  accepts_nested_attributes_for :description_images, allow_destroy: true
  accepts_nested_attributes_for :product_sizes, allow_destroy: true

  validates :name, :description, :instructions, presence: true
  validates :price, :stock_quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  # validates_presence_of :images, :product_categories, :description_images
  validates :images, :product_categories, :description_images, presence: true, on: :create

  enum product_size: ['small', 'medium', 'large']

  scope :with_images, -> { joins(:images_attachments) }

  before_save :process_tags

  def process_tags
    self.colors = colors.is_a?(String) ? colors.split(',').map(&:strip) : colors
    self.sizes = sizes.is_a?(String) ? sizes.split(',').map(&:strip) : sizes
  end

  def image_urls
    images.map { |image| Rails.application.routes.url_helpers.url_for(image) } if images.attached?
  end

  def self.ransackable_scopes(auth_object = nil)
    [:with_images]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "id_value", "is_active", "name", "price", "product_size", "stock_quantity", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["categories", "images_attachments", "images_blobs", "order_items", "orders", "product3_d_models", "product_categories", "product_images", "reviews", "virtual_room_items", "wishlists"]
  end

  pg_search_scope :search_by_attributes,
    against: [:name, :description],
    associated_against: { categories: [:name, :description] },
    using: {
      tsearch: { prefix: true, any_word: true },
      trigram: {}
    }

end
