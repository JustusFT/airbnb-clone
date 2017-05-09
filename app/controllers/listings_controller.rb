class ListingsController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def index
    @query_params = request.query_parameters
    @query_params.delete_if { |key, value| value == "" }
    @query_params[:page] ||= 1
    @query_params[:min_bed_count] ||= 0
    @listings = Listing.bed_count(@query_params[:min_bed_count])
    @listings = @listings.room_type(@query_params[:room_types]) unless @query_params[:room_types].nil?
    @listings = @listings.tags(@query_params[:tags]) unless @query_params[:tags].nil?
    @listings = @listings.amenities(@query_params[:amenities]) unless @query_params[:amenities].nil?
    @listings = @listings.date_overlap(@query_params[:check_out]) unless @query_params[:check_in].nil? || @query_params[:check_out].nil?
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
  end

  def edit
    @listing = Listing.find(params[:id])
    unless @listing.user_id == current_user.id
      redirect_to @listing
    end
  end

  def update
    @listing = Listing.find(params[:id])
    @listing.update_attributes(strong_params)

    @listing.amenity_list = []
    params[:amenities].each do |k, v|
      @listing.amenity_list.add(k)
    end

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
