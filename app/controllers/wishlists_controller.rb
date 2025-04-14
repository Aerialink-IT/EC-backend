class WishlistsController < ApplicationController

  def index
    products = Product.includes(:product_sizes, :reviews, :wishlists)
                    .where(id: current_user.wishlists.pluck(:product_id))
    render json: products, each_serializer: ProductSerializer, scope: current_user
  end

  def create
    wishlist = current_user.wishlists.find_or_create_by(product_id: params[:product_id])

    if wishlist.persisted?
      render json: { message: "Product added to wishlist" }, status: :ok
    else
      render json: { error: "Could not add product to wishlist", details: wishlist.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    wishlist_item = current_user.wishlists.find_by(product_id: params[:product_id])

    if wishlist_item
      wishlist_item.destroy
      render json: { message: "Product removed from wishlist" }, status: :ok
    else
      render json: { error: "Wishlist item not found" }, status: :not_found
    end
  end
end
