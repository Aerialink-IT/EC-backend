class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  before_save :set_prices
  after_save :update_cart_totals
  after_destroy :update_cart_totals

  def set_prices
    self.unit_price = product.product_sizes.find_by(size: self.size).price unless unit_price
    self.total_price = unit_price * quantity
  end

  private

  def update_cart_totals
    cart.save
  end
end
