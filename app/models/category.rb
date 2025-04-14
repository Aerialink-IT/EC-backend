class Category < ApplicationRecord
  has_many :product_categories, dependent: :destroy
  has_many :products, through: :product_categories
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :subcategories, class_name: 'Category', foreign_key: 'parent_id'
  has_one_attached :image

  validates :name, :description, presence: true
  validates_presence_of :image

  scope :with_images, -> { joins(:image_attachments) }

  def self.ransackable_scopes(auth_object = nil)
    [:with_images]
  end

  def self.ransackable_associations(auth_object = nil)
    ["parent", "product_categories", "products", "subcategories"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "name_jp", "description_jp", "id", "id_value", "name", "parent_id", "updated_at"]
  end

  def translated_name
    I18n.locale == :ja ? name_jp : name
  end

  def translated_description
    I18n.locale == :ja ? description_jp : description
  end
end
