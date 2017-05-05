class ReservationJob < ApplicationJob
  queue_as :default

  def perform(user)
    ReservationMailer.booking_email(user).deliver_now
  end
end
