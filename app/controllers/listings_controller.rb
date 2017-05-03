class ListingsController < ApplicationController
  before_action :require_login, only: [:new, :create]

  def index
    @query_params = request.query_parameters
    @query_params.delete_if { |key, value| value == "" }
    @query_params[:page] ||= 1
    @query_params[:min_bed_count] ||= 0
    @listings = Listing.order(created_at: :desc)
    @listings = @listings.where(room_type: @query_params[:room_types].to_a.map { |x| x[0] }) unless @query_params[:room_types].nil?
    @listings = @listings.where("bed_count >= ?", @query_params[:min_bed_count])
    @listings = @listings.tagged_with(@query_params[:tags], any: true) unless @query_params[:tags].nil?
    p @query_params[:amenities]
    @listings = @listings.tagged_with(@query_params[:amenities].to_a.map { |x| x[0] }, on: :amenities, any: true) unless @query_params[:amenities].nil?
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

  private
  def strong_params
    params.require(:listing).permit(:user_id, :name, :description, :price, :address, :room_type, :room_count, :bed_count, :guest_count, :tag_list, photos: [])
  end
end
