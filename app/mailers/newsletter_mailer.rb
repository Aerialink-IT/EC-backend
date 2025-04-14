class NewsletterMailer < ApplicationMailer
  default from: 'from@example.com'

  def confirmation_email(subscription)
    @subscription = subscription
    mail(to: @subscription.email, subject: "Thank you for subscribing to our Newsletter!")
  end
end
