class BookingsController < ApplicationController
  def new
    @listing = Listing.find(params[:listing_id])
    @booking = Booking.new
    render :"bookings/new"
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
