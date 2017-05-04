class BraintreeController < ApplicationController
  def new
    # byebug
    @client_token = Braintree::ClientToken.generate
  end

  def checkout
    byebug
    nonce_from_the_client = params[:checkout_form][:payment_method_nonce]

    result = Braintree::Transaction.sale(
      :amount => Listing.find(session[:booking]["listing_id"]).price * (Date.parse(session[:booking]["check_out"]) - Date.parse(session[:booking]["check_in"])).to_f, #this is currently hardcoded
      :payment_method_nonce => nonce_from_the_client,
      :options => {
        :submit_for_settlement => true
      }
    )

    if result.success?
      # byebug
      Booking.new(session[:booking]).save!
      redirect_to :root, :flash => { :success => "Transaction successful!" }
    else
      redirect_to :root, :flash => { :error => "Transaction failed. Please try again." }
    end
  end
end
