class InquiryFormsController < ApplicationController

  def create
    inquiry = InquiryForm.new(inquiry_params)
    inquiry.user = current_user
    if inquiry.save
      InquiryMailer.new_inquiry(inquiry).deliver_now
      render json: { message: "Inquiry submitted successfully", inquiry: inquiry }, status: :created
    else
      render json: { errors: inquiry.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def inquiry_params
    params.require(:inquiry_form).permit(:full_name, :email, :phone_number, :order_number, :message)
  end
end