class NewsletterSubscription < ApplicationRecord
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  after_create :send_confirmation_email

  scope :active, -> { where(subscription_enabled: true) }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "id", "id_value", "subscription_enabled", "updated_at"]
  end
  private

  def send_confirmation_email
    NewsletterMailer.confirmation_email(self).deliver_later
  end
end
