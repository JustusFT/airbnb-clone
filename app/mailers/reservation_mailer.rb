class ReservationMailer < ApplicationMailer
  def booking_email(user)
    @user = user
    mail(to: @user.email, content_type: "text/html", subject: 'Booked!')
  end
end
