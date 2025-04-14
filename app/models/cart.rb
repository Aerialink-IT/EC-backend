class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, -> { order(:created_at) }, dependent: :destroy
  has_many :products, through: :cart_items

  accepts_nested_attributes_for :cart_items, allow_destroy: true

  before_save :calculate_totals

  def subtotal
    cart_items.sum { |item| item.total_price }
  end

  private

  def calculate_totals
    self.subtotal = cart_items.sum(&:total_price)
    self.shipping_fee ||= 0
    self.total = subtotal + self.shipping_fee.to_f
  end
end
