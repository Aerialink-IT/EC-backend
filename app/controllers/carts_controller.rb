class CartsController < ApplicationController
  before_action :set_cart

  def get_cart
    render json: @cart, serializer: CartSerializer
  end


  def add_item
    return render json: { error: "Product not found" }, status: :not_found unless Product.find_by(id: params[:product_id])
    item = if params[:size].present?
      @cart.cart_items.find_or_initialize_by(product_id: params[:product_id], size: params[:size])
    else
      @cart.cart_items.find_or_initialize_by(product_id: params[:product_id])
    end
    process_quantity(item, params[:quantity])
    if params[:size].present?
      item.size = params[:size]
    else
      item.size = item.product.product_sizes.first.size
    end
    if item.save
      render json: { message: "Item added to cart successfully", cart: @cart.reload }, status: :created
    else
      render json: { error: "Unable to add item to cart", details: item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_item
    item = @cart.cart_items.find_by(id: params[:id])
    return render json: { error: "Item not found" }, status: :not_found unless item.present?
    process_quantity(item, params[:quantity])
    # item.size = params[:size] if params[:size].present?
    if params[:size].present?
      product_size = item.product.product_sizes.find_by(size: params[:size])
      return render json: { error: "Invalid size selected" }, status: :unprocessable_entity unless product_size
  
      item.size = params[:size]
      item.unit_price = product_size.price
    end

    if item.save
      render json: { message: "Item updated successfully", cart: @cart.reload }, status: :ok
    else
      render json: { error: "Unable to update item", details: item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def remove_item
    item = @cart.cart_items.find_by(id: params[:id])

    if item&.destroy
      render json: { message: "Item removed from cart", cart: @cart.reload }, status: :ok
    else
      error_message = item.nil? ? "Item not found" : "Unable to remove item"
      render json: { error: error_message }, status: item.nil? ? :not_found : :unprocessable_entity
    end
  end

  def clear
    if @cart.cart_items.destroy_all
      render json: { message: "Cart cleared successfully", cart: @cart.reload }, status: :ok
    else
      render json: { error: "Unable to clear cart" }, status: :unprocessable_entity
    end
  end

  private

  def set_cart
    @cart = current_user.cart || current_user.create_cart
  end

  def validate_stock(item, quantity)
    if quantity > item.product.stock_quantity
      render json: { error: "Insufficient stock quantity", available_stock: item.product.stock_quantity }, status: :unprocessable_entity
      return false
    end
    true
  end

  def process_quantity(item, quantity_param)
    quantity = quantity_param.to_i
    if quantity && quantity > 0
      return unless validate_stock(item, quantity)
      item.quantity = quantity
    end
  end
end
