class OrderMailer < ApplicationMailer
  default from: "#{ENV["EMAIL_USERNAME"]}"
  def guest_order_confirmation(order)
    @order = order
    @email = order&.delivery_address&.email
    mail(to: @email, subject: "Order Confirmation ##{order.id}")
  end
end
