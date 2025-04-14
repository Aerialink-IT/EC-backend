class About < ApplicationRecord
  has_many_attached :images

  validate :single_record

  private

  def single_record
    if About.exists? && !persisted?
      errors.add(:base, "Only one About record is allowed")
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["address", "community_time", "contact_us_time", "created_at", "description", "email", "id", "id_value", "map_url", "phone", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["images_attachments", "images_blobs"]
  end

  def gallery_images
    images.map { |image| Rails.application.routes.url_helpers.url_for(image) } if images.attached?
  end
end
