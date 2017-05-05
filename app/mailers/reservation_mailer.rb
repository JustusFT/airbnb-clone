class ReservationMailer < ApplicationMailer
  def booking_email(user)
    @user = user
    mail(to: @user.email, subject: 'Booked!')
  end
end
