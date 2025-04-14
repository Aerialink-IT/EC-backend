class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :update, :destroy, :check_order_payment_status, :apply_reward_points, :apply_coupon]
  before_action :find_product, only: [:create_order]
  before_action :restrict_guest_users, only: [:index, :show,:create_order, :apply_reward_points, :apply_coupon]

  def index
    orders = current_user.orders.where(status: ["confirmed", "cancelled"]).order(created_at: :desc)
    orders = paginate(orders)

    formatted_orders = orders.map do |order|
      {
        invoice_no: "##{order.id}",
        date: order.created_at.strftime("%d-%m-%Y"),
        amount: order.total_amount,
        status: order.status.humanize,
      }
    end

    render json: { orders: formatted_orders, meta: pagination_meta(orders) }
  end

  def show
    render json: @order, include: [:order_items, :products]
  end

  def create_order
    return render json: { error: 'quantity not present' }, status: :bad_request if params["order"]["quantity"].blank? && params["order"]["quantity"].to_i <= 0
    order = current_user.orders.new(status: "created")
    if order.save
      order_item = order.order_items.create(product_id: @product.id, quantity: params["order"]["quantity"], unit_price: @product.price, size:  params["order"]["size"])
      order.update(sub_total: order_item.total_price)
      render json: order.as_json(include: [:order_items]), status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def create_order_from_cart
    begin
      cart = Cart.find_by!(id: params[:cart_id], user_id: current_user.id)
    rescue ActiveRecord::RecordNotFound
      return render json: { error: "Cart not found" }, status: :unprocessable_entity
    end
    
    if cart.cart_items.empty?
      return render json: { error: "Cart is empty" }, status: :unprocessable_entity
    end

    if cart.cart_items.any? { |cart_item| cart_item.size.nil? }
      return render json: { error: "Size cannot be null for any cart item" }, status: :unprocessable_entity
    end

    billing_detail = current_user.billing_details.find_by(is_default: true) || current_user.billing_details&.last

    order = current_user.orders.new(
      sub_total: cart.cart_items.sum(:total_price),
      status: "created",
      billing_detail_id: billing_detail&.id
    )

    if order.save
      cart.cart_items.each do |cart_item|
        order.order_items.create!(
          product_id: cart_item.product_id,
          quantity: cart_item.quantity,
          unit_price: cart_item.unit_price,
          size: cart_item.size
        )
      end
      order.update(total_amount: order.total_price)
      render json: {
        order: order.as_json(
          include: {
            order_items: {
              include: {
                product: {
                  only: [:name],
                  methods: [:image_urls]
                }
              },
              only: [:product_id, :quantity, :unit_price, :size, :total_price]
            },
            billing_detail: {
              only: [:id, :full_name, :phone_number, :street_address, :postal_code, :is_default]
            }
          }
        ),
        reward_points: current_user&.reward_point&.reward_points,
        delivery_addresses: current_user.delivery_addresses.as_json(only: [:id, :first_name, :last_name, :line1, :line2, :prefecture, :post_code, :phone_number, :email, :status])
      }, status: :ok
    else
      render json: order.errors, status: :unprocessable_entity
    end
  end

  def update
    if @order.update(order_params)
      render json: @order.as_json(include: [:order_items, :products])
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy
    render json: { message: "Order deleted successfully" }
  end

  def check_order_payment_status
    payment_transaction = @order&.payment_transaction
    billing_address = @order&.billing_detail
    delivery_address = @order&.delivery_address
    customer_info = {
      full_name: billing_address&.full_name,
      phone_number: billing_address&.phone_number,
      email: current_user&.email,
      street_address: billing_address&.street_address,
      postal_code: billing_address&.postal_code
    }
    response_data = {
      order: @order.as_json(
        include: {
          order_items: {
            include: {
              product: {
                only: [:name],
                methods: [:image_urls]
              }
            },
            only: [:product_id, :quantity, :unit_price, :size]
          }
        }
      ),
      customer_info: customer_info,
      payment_transaction: payment_transaction,
      delivery_address: delivery_address,
      total_amount: @order.total_amount.to_f
    }

    render json: response_data, status: :ok
  end

  def apply_reward_points
    points_to_apply = params[:points_to_apply].to_i
    if current_user.reward_point.reward_points < points_to_apply
      render json: { error: "Insufficient reward points" }, status: :unprocessable_entity
      return
    end

    new_total = (@order.total_amount + @order.reward_points_used.to_i) - points_to_apply

    @order.update(total_amount: new_total, reward_points_used: points_to_apply)
    render json: { message: "Points applied successfully",
      order: @order.as_json(
        include: {
          order_items: {
            include: {
              product: {
                only: [:name],
                methods: [:image_urls]
              }
            },
            only: [:product_id, :quantity, :unit_price, :size, :total_price]
          },
          billing_detail: {
            only: [:id, :full_name, :phone_number, :street_address, :postal_code, :is_default]
          }
        }
      ),
      reward_points: current_user&.reward_point&.reward_points,
      delivery_addresses: current_user.delivery_addresses.as_json(only: [:id, :first_name, :last_name, :line1, :line2, :prefecture, :post_code, :phone_number, :email, :status])
    }, status: :ok
  end

  def update_delivery_address
    order = Order.find(params[:order_id])
    delivery_address = current_user.delivery_addresses.find(params[:delivery_address_id])
  
    if order.update(delivery_address: delivery_address)
      render json: { message: "Delivery address updated successfully", order: order }, status: :ok
    else
      render json: { error: order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def apply_coupon
    if @order.coupon_code.present?
      # previous_discount = @order.coupon_amount.to_d
      # @order.update(sub_total: @order.sub_total.to_d + previous_discount, coupon_code: nil, coupon_amount: 0)
      total_amount = (@order.sub_total.to_d || 0) + (@order.delivery_fees.to_d || 0)
      @order.update(total_amount: total_amount, coupon_code: nil, coupon_amount: 0)
    end

    coupon_code = params[:coupon_code]&.strip
    return render json: { error: "Coupon code is required" }, status: :unprocessable_entity if coupon_code.blank?

    coupon = Coupon.find_by(code: coupon_code, status: "active")
    return render json: { error: "Invalid or expired coupon" }, status: :unprocessable_entity unless coupon

    if CouponUsageHistory.exists?(user: current_user, coupon_code: coupon_code)
      return render json: { error: "Coupon already used" }, status: :unprocessable_entity
    end

    discount_amount = calculate_discount(@order, coupon)
    new_total = @order.total_amount - discount_amount
    # @order.update(sub_total: new_total)
    total_amount = (new_total.to_d || 0) + (@order.delivery_fees.to_d || 0)
    @order.update(total_amount: total_amount, coupon_amount: discount_amount, coupon_code: coupon.code)
    render json: { message: "Coupon applied successfully",
      order: @order.as_json(
        include: {
          order_items: {
            include: {
              product: {
                only: [:name],
                methods: [:image_urls]
              }
            },
            only: [:product_id, :quantity, :unit_price, :size, :total_price]
          },
          billing_detail: {
            only: [:id, :full_name, :phone_number, :street_address, :postal_code, :is_default]
          }
        }
      ),
      reward_points: current_user&.reward_point&.reward_points,
      delivery_addresses: current_user.delivery_addresses.as_json(only: [:id, :first_name, :last_name, :line1, :line2, :prefecture, :post_code, :phone_number, :email, :status])
    }, status: :ok
  end

  private

  def find_product
    begin
      @product = Product.find(params["order"]["product_id"])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Product not found" }, status: :not_found
    end
  end

  def set_order
    begin
      @order = current_user.orders.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Order not found" }, status: :not_found
    end
  end

  def calculate_discount(order, coupon)
    if coupon.discount_type == "percentage"
      (order.sub_total * (coupon.discount_value / 100.0)).round(2)
    elsif coupon.discount_type == "fixed"
      coupon.discount_value
    else
      0
    end
  end

  def restrict_guest_users
    if current_user.guest_user?
      render json: { error: "Guest users are not allowed to perform this action" }, status: :forbidden
    end
  end

  def order_params
    params.require(:order).permit(:total_amount, :loyalty_points_used, :status, order_items_attributes: [:product_id, :quantity, :unit_price])
  end
end
