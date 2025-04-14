class NewsletterSubscriptionsController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]

  def create
    @subscription = NewsletterSubscription.new(newsletter_params)
    @subscription.subscription_enabled = true
    if @subscription.save
      render json: { message: "Successfully subscribed!" }, status: :created
    else
      render json: { errors: @subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def newsletter_params
    params.require(:newsletter_subscription).permit(:email)
  end
end