class ListingsController < ApplicationController
  before_action :require_login

  def new
    @listing = Listing.new
    render :"listings/new"
  end

  def create
    @listing = current_user.listings.new(strong_params)

    params[:amenities].each do |k, v|
      @listing.amenity_list.add(k)
    end

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
    params.require(:listing).permit(:user_id, :name, :description, :price, :address, :room_count, :bed_count, :guest_count, :tag_list)
  end
end
