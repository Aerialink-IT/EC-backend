class Message < ApplicationRecord
  belongs_to :chat
  belongs_to :sender, polymorphic: true

  validates :content, presence: true

  scope :unread, -> { where(read: false) }
end
