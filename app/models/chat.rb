class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :admin_user

  has_many :messages, dependent: :destroy

  scope :unread, -> { where(unread_messages: true) }

  def self.ransackable_attributes(auth_object = nil)
    ["id", "user_id", "admin_user_id", "unread_messages", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "admin_user", "messages"]
  end
end
