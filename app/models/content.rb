class Content < ApplicationRecord
  has_one_attached :image
  
  validates :key, presence: true, uniqueness: true
  validates :section, presence: true
  
  # Ransack configuration for ActiveAdmin filtering/searching
  def self.ransackable_attributes(auth_object = nil)
    ["content_en", "content_ja", "created_at", "description", "id", "id_value", "key", "section", "updated_at"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    []
  end
  
  # Get content for a specific locale
  def content_for(locale)
    case locale.to_s
    when 'ja'
      content_ja.presence || content_en
    when 'en'
      content_en.presence || content_ja
    else
      content_en
    end
  end
  
  # Class method to get content by key and locale
  def self.get(key, locale = 'en')
    content = find_by(key: key)
    return nil unless content
    content.content_for(locale)
  end
  
  # Get all content for a section
  scope :by_section, ->(section) { where(section: section) }
end
