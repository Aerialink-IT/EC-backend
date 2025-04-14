class PaymentsController < ApplicationController
  def create_session
    order = Order.find_by(id: params[:order_id], user_id: current_user.id)
    return render json: { error: "Order not found" }, status: :not_found if order.nil?

    if order.delivery_address.blank?
      return render json: { error: "Delivery address is required." }, status: :unprocessable_entity
    end
  
    if params[:form_edited] == true
      billing_detail = current_user.billing_details.create(
        full_name: params[:full_name],
        phone_number: params[:phone_number],
        street_address: params[:street_address],
        postal_code: params[:postal_code],
        is_default: params[:save_as_default] || false
      )
      if params[:save_as_default] == true
        current_user.billing_details.where.not(id: billing_detail.id).update_all(is_default: false)
      end
    else
      billing_detail = current_user.billing_details.find_by(is_default: true) || current_user.billing_details.last
      if billing_detail.nil?
        return render json: { error: "No existing billing details found. Please enter billing details." }, status: :unprocessable_entity
      end
    end

    if params[:payment_method].present?
      user_payment_method = current_user.user_payment_methods.find_or_create_by(
        payment_type: params[:payment_method]
      ) do |upm|
        upm.is_default = true
      end
    else
      user_payment_method = current_user.user_payment_methods.find_by(is_default: true)
      if user_payment_method.nil?
        return render json: { error: "No default payment method found. Please provide a payment method." }, status: :unprocessable_entity
      end
    end
    order.update(billing_detail_id: billing_detail.id, payment_method: user_payment_method.payment_type)

    if params[:payment_method] == "komoju"
      amount = order.total_amount || "1000"
      email = current_user.email || "test@gmail.com"
      return_url = params[:return_url]
      cancel_url = params[:cancel_url]
      response = KomojuService.create_session(amount, email, return_url, cancel_url, { order_id: order.id.to_s })
      response_body = JSON.parse(response.body)
      if response.code == "200"
        order.update(payment_method: "komoju", session_id: response_body["id"])
        render json: { session_url: response_body["session_url"] }, status: :ok
      else
        render json: { error: response_body }, status: :unprocessable_entity
      end
    elsif params[:payment_method] == "cash_on_delivery"
      success = WebhooksController.new.clear_cart_and_update_products_quant(order)
      OrderMailer.guest_order_confirmation(order).deliver_now if current_user&.guest_user?
      order.update(payment_method: "cash_on_delivery", payment_status: "cod_pending", status: "confirmed")
      if order.save
        render json: { message: "Order placed successfully", order: order }, status: :created
      else
        render json: { error: order.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def transaction_history
    render json: {transaction_history: ActiveModelSerializers::SerializableResource.new(current_user.payment_transactions, each_serializer: PaymentTransactionSerializer)}
  end
end
