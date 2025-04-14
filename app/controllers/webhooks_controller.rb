class WebhooksController < ApplicationController
  skip_before_action :authenticate_request

  def komoju
    order_id = params.dig(:data, :metadata, :order_id) || params.dig(:webhook, :data, :metadata, :order_id)
    session_id = params.dig(:data, :session) || params.dig(:webhook, :data, :session)
    order = Order.find_by(id: order_id, session_id: session_id)

    if order.present?
      session_data = KomojuService.check_payment_status(session_id)
      payment_status = session_data["status"]
      payment_details = session_data["payment"]["payment_details"]
   
      PaymentTransaction.create!(
        order_id: order.id,
        user_payment_method_id: order.user.user_payment_methods.last.id,
        amount: session_data["amount"],
        status: payment_status,
        transaction_id: session_data["payment"]["id"],
        payment_gateway: "Komoju",
        currency: session_data["currency"],
        payment_type: payment_details["type"],
        payment_details: payment_details.to_json,
        gateway_status: session_data["payment"]["status"],
        captured_at: session_data["payment"]["captured_at"],
        amount_refunded: session_data["payment"]["amount_refunded"]
      )
      current_user = order.user
      case payment_status
      when "completed"
        unless order.payment_status == "paid"
          update_order_status(order, "paid", "confirmed")
          clear_cart_and_update_products_quant(order)
          process_successful_payment(order)
          # clear_cart_and_update_products_quant(order)
          # current_user.tiers_points.active.last.check_tier_expiry(current_user)
          # current_user.reward_point.add_points(current_user, order.total_amount, order_id)
          # current_user.reward_point.use_points_for_order(order_id)
          # create_coupon_usage_history(order)
        end
        render json: { payment_status: "completed" }, status: :ok
      when "pending"
        update_order_status(order, "pending", "placed")
        render json: { payment_status: "pending" }, status: :ok
      when "cancelled"
        update_order_status(order, "failed", "cancelled")
        render json: { payment_status: "cancelled" }, status: :ok
      end
    else
      render json: { error: "Order not found" }, status: :not_found
    end
  end

  def confirm_delivery(order_id, from_admin: false)
    @order = Order.find_by(id: order_id)
    @order.update(payment_status: "cod_received", status: "delivered")
    if @order.save
      process_successful_payment(@order)
      return true if from_admin 
      # render json: { message: "Order placed successfully", order: @order }, status: :created
    else
      return false if from_admin 
      # render json: { error: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def clear_cart_and_update_products_quant(order)
    ActiveRecord::Base.transaction do
      order.order_items.each do |order_item|
        product = order_item.product
        new_stock_quantity = product.stock_quantity - order_item.quantity
        if new_stock_quantity >= 0
          product.update_columns(stock_quantity: new_stock_quantity)
        else
          raise ActiveRecord::Rollback, "Insufficient stock for product ID: #{product.id}"
        end
      end

      Cart.where(user_id: order.user_id).destroy_all
    end
  end

  private

  def process_successful_payment(order)
    return unless order.present?
    current_user = order.user
    return unless current_user.present?

    OrderMailer.guest_order_confirmation(order).deliver_now if current_user&.guest_user?
  
    unless current_user.guest_user
      current_user.tiers_points.active.last&.check_tier_expiry(current_user)
      current_user.reward_point&.add_points(current_user, order.total_amount, order.id)
      current_user.reward_point&.use_points_for_order(order.id)
      create_coupon_usage_history(order)
    end
  end

  def create_coupon_usage_history(order)
    return unless order.coupon_code.present?
    coupon = Coupon.find_by(code: order.coupon_code, status: "active")
    CouponUsageHistory.create!(
      user_id: order.user.id,
      order_id: order.id,
      coupon_id: coupon.id,
      coupon_code: order.coupon_code,
      discount_value: order.coupon_amount,
      used_at: Time.current
    )
  end

  def update_order_status(order, payment_status, order_status)
    order.update(payment_status: payment_status, status: order_status)
  end
end
