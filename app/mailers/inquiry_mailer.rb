class InquiryMailer < ApplicationMailer
  default from: 'from@example.com'

  def new_inquiry(inquiry)
    @inquiry = inquiry
    @admin = AdminUser.all.last
    mail(to: @admin.email, subject: "New Inquiry from #{@inquiry.full_name}")
  end

end
