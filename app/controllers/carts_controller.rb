class CartsController < ApplicationController
  before_action :set_cart

  def get_cart
    render json: @cart, serializer: CartSerializer
  end


  def add_item
    product = Product.find_by(id: params[:product_id])
    return render json: { error: "Product not found" }, status: :not_found unless product
    
    # Handle size assignment
    if params[:size].present?
      product_size = product.product_sizes.find_by(size: params[:size])
      return render json: { error: "Invalid size selected" }, status: :unprocessable_entity unless product_size
      item = @cart.cart_items.find_or_initialize_by(product_id: params[:product_id], size: params[:size])
      item.size = params[:size]
      item.unit_price = product_size.price
    else
      # If no size provided, check if product has sizes
      if product.product_sizes.any?
        first_size = product.product_sizes.first
        item = @cart.cart_items.find_or_initialize_by(product_id: params[:product_id], size: first_size.size)
        item.size = first_size.size
        item.unit_price = first_size.price
      else
        # Product has no sizes, create item without size
        item = @cart.cart_items.find_or_initialize_by(product_id: params[:product_id])
        item.unit_price = product.price
      end
    end
    
    # Process quantity
    quantity = params[:quantity].to_i
    if quantity && quantity > 0
      unless validate_stock(item, quantity)
        return # Stop execution if stock validation fails
      end
      item.quantity = quantity
    else
      item.quantity ||= 1
      # Validate stock for default quantity too
      unless validate_stock(item, item.quantity)
        return # Stop execution if stock validation fails
      end
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
    unless current_user
      return render json: { error: "User not authenticated" }, status: :unauthorized
    end
    @cart = current_user.cart || current_user.create_cart
  rescue => e
    Rails.logger.error "Error setting cart: #{e.message}"
    render json: { error: "Unable to access cart", details: e.message }, status: :internal_server_error
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
      return false unless validate_stock(item, quantity)
      item.quantity = quantity
      return true
    end
    false
  end
end
