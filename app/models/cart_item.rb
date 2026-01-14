class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  before_save :set_prices
  after_save :update_cart_totals
  after_destroy :update_cart_totals

  def set_prices
    unless unit_price
      if self.size.present?
        product_size = product.product_sizes.find_by(size: self.size)
        if product_size
          self.unit_price = product_size.price
        else
          # Size specified but not found, use product base price
          self.unit_price = product.price
        end
      else
        # No size specified, use product base price
        self.unit_price = product.price
      end
    end
    self.total_price = (unit_price || 0) * (quantity || 0)
  end

  private

  def update_cart_totals
    cart.save
  end
end
