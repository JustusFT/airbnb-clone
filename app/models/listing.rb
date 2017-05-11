class Listing < ApplicationRecord
  include PgSearch
  pg_search_scope :search,
    against: [:name, :description, :address],
    associated_against: {tags: [:name]}

  validates_presence_of :user_id, :price, :address, :room_count, :bed_count, :guest_count
  validate :one_photo_required
  before_create :one_photo_required
  acts_as_taggable
  acts_as_taggable_on :amenities
  belongs_to :user
  has_many :bookings
  default_scope { order(created_at: :desc) }
  scope :room_type, ->(types) { where(room_type: types.to_a.map { |x| x[0] }) }
  scope :bed_count, ->(count) { where("bed_count >= ?", count) }
  scope :tags, ->(tags) { tagged_with(tags, any: true) }
  scope :amenities, ->(amenities) { tagged_with(amenities.to_a.map { |x| x[0] }, on: :amenities, any: true) }
  scope :date_overlap, ->(check_out, check_in) { includes(:bookings).where.not("listings.id IN (SELECT listing_id FROM bookings) AND bookings.check_in <= ? AND bookings.check_out >= ?", check_out, check_in).references(:bookings) }
  scope :search_bar, ->(query) { search(query) }
  enum room_type: [ :entire_home, :private_room, :shared_room ]

  mount_uploaders :photos, ListingPhotoUploader
  before_destroy :destroy_assets

  def destroy_assets
    self.photos.each {|x| x.remove!}
  end

  def one_photo_required
    unless self.photos?
      errors.add(:photos, "can't be empty")
      return false
    end
  end

  def self.filter(params={})
    params[:page] ||= 1
    params[:min_bed_count] ||= 0

    listings = Listing.bed_count(params[:min_bed_count])
    listings = listings.room_type(params[:room_types]) unless params[:room_types].nil?
    listings = listings.tags(params[:tags]) unless params[:tags].nil?
    listings = listings.amenities(params[:amenities]) unless params[:amenities].nil?
    listings = listings.date_overlap(params[:check_out]) unless params[:check_in].nil? || params[:check_out].nil?
    listings = listings.search_bar(params[:search]) unless params[:search].nil?

    listings
  end
end
