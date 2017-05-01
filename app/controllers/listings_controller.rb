class ListingsController < ApplicationController
  before_action :require_login

  def index
    @query_params = request.query_parameters
    @query_params.delete_if { |key, value| value == "" }
    @query_params[:page] ||= 1
    @query_params[:min_bed_count] ||= 0
    @listings = Listing.order(created_at: :desc)
    @listings = @listings.where(room_type: @query_params[:room_types].to_a.map { |x| x[0] }) unless @query_params[:room_types].nil?
    @listings = @listings.where("bed_count >= ?", @query_params[:min_bed_count])
    p "------------------------"
    p @query_params[:tags]
    p "------------------------"
    @listings = @listings.tagged_with(@query_params[:tags], any: true) unless @query_params[:tags].nil?
  end

  def new
    @listing = Listing.new
    render :"listings/new"
  end

  def create
    @listing = current_user.listings.new(strong_params)
    @listing.photos = params[:listing][:photos]

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

  private
  def strong_params
    params.require(:listing).permit(:user_id, :name, :description, :price, :address, :room_type, :room_count, :bed_count, :guest_count, :tag_list)
  end
end
