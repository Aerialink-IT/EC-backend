class DeliveryAddressesController < ApplicationController
  before_action :set_delivery_address, only: [:update_delivery_address, :set_default, :remove_delivery_address]


  def index
    delivery_addresses = current_user.delivery_addresses.order(status: :desc, created_at: :desc)
    render json: { delivery_addresses: delivery_addresses }, status: :ok
  end

  def create
    delivery_address = current_user.delivery_addresses.new(delivery_address_params)

    if delivery_address.save
      render json: { message: "Delivery address added successfully", delivery_address: delivery_address }, status: :created
    else
      render json: { errors: delivery_address.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_delivery_address
    if @delivery_address.update(delivery_address_params)
      render json: { message: "Delivery address updated successfully", delivery_address: @delivery_address }, status: :ok
    else
      render json: { errors: @delivery_address.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def set_default
    current_user.delivery_addresses.update_all(status: false)

    if @delivery_address.update(status: true)
      render json: { message: "Default delivery address updated", delivery_address: @delivery_address }, status: :ok
    else
      render json: { errors: @delivery_address.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def remove_delivery_address
    if @delivery_address.destroy
      render json: { message: "Delivery address removed successfully" }, status: :ok
    else
      render json: { errors: "Failed to remove delivery address" }, status: :unprocessable_entity
    end
  end

  private

  def set_delivery_address
    @delivery_address = current_user.delivery_addresses.find_by(id: params[:id])
    render json: { error: "Delivery address not found" }, status: :not_found unless @delivery_address
  end

  def delivery_address_params
    params.require(:delivery_address).permit(:first_name, :last_name, :line1, :line2, :prefecture, :post_code, :phone_number, :email)
  end
end
