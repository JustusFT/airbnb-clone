class ListingsController < ApplicationController
  before_action :require_login

  def new
    @listing = Listing.new
    render :"listings/new"
  end

  def create
    @listing = Listing.new(strong_params)
    @listing.user_id = current_user.id
    if @listing.save
      redirect_to @listing
    else
      redirect_to "/listings/new"
    end
  end

  def show
    # byebug
  end

  private
  def strong_params
    params.require(:listing).permit(:user_id, :description, :price, :address, :room_count, :bed_count, :guest_count, :tag_list)
  end
end
