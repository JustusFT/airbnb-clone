class BraintreeController < ApplicationController
  before_action :make_booking

  def new
    @client_token = Braintree::ClientToken.generate
    @listing = @booking.listing
    @price = @listing.price * (@booking.check_out - @booking.check_in).to_f
  end

  def checkout
    nonce_from_the_client = params[:checkout_form][:payment_method_nonce]

    price = @booking.listing.price * (@booking.check_out - @booking.check_in).to_f

    result = Braintree::Transaction.sale(
      :amount => price,
      :payment_method_nonce => nonce_from_the_client,
      :options => {
        :submit_for_settlement => true
      }
    )

    if result.success?
      @booking.save!
      redirect_to :root, :flash => { :success => "Transaction successful!" }
    else
      redirect_to :root, :flash => { :error => "Transaction failed. Please try again." }
    end
  end

  private
  def make_booking
    @booking = Booking.new(session[:booking])

    unless @booking.valid?
      flash[:notice] = "ERROR, booking is not valid?"
      redirect_to @booking.listing || "/listings"
    end
  end
end
