class ListingsController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def index
    @query_params = request.query_parameters
    @query_params.delete_if { |key, value| value == "" }
    @listings = Listing.filter(@query_params)
  end

  def new
    @listing = Listing.new
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
    @listing = Listing.find(params[:id])
    @user = @listing.user
  end

  def edit
    @listing = current_user.listings.find(params[:id])
  end

  def update
    @listing = Listing.find(params[:id])
    @listing.update_attributes(strong_params)
    @listing.amenity_list = params[:amenities].map { |k, v| k }

    unless @listing.save
      flash[:notice] = "Error updating???"
    end
    redirect_to @listing
  end

  def destroy
    @listing = Listing.find(params[:id])
    unless @listing.destroy
      flash[:notice] = "Error deleting?"
      redirect_to @listing
    end
    redirect_to "/listings"
  end

  private
  def strong_params
    params.require(:listing).permit(:user_id, :name, :description, :price, :address, :room_type, :room_count, :bed_count, :guest_count, :tag_list, photos: [])
  end
end
