class InquiryForm < ApplicationRecord
  belongs_to :user

  validates :full_name, :email, :phone_number, :message, presence: true
end
