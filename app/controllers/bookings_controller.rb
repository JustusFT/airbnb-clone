class BookingsController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def new
    @listing = Listing.find(params[:listing_id])
    @booking = Booking.new

    @taken_dates = []
    @listing.bookings.each do |x|
      x.check_in.upto(x.check_out) do |x|
        @taken_dates << x.to_s
      end
    end
  end

  def create
    @listing = Listing.find(params[:listing_id])
    @booking = @listing.bookings.new(strong_params)
    @booking.user_id = current_user.id
    if @booking.save
      redirect_to [@listing, @booking]
    else
      flash[:notice] = @booking.errors.messages
      redirect_to @listing
    end
  end

  private
  def strong_params
    params.require(:booking).permit(:user_id, :listing_id, :check_in, :check_out)
  end
end
