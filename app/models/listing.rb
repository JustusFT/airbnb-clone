class Listing < ApplicationRecord
  include PgSearch
  pg_search_scope :search, against: [:name, :description, :address]

  validates_presence_of :user_id, :price, :address, :room_count, :bed_count, :guest_count
  validate :one_photo_required
  before_create :one_photo_required
  acts_as_taggable
  acts_as_taggable_on :amenities
  belongs_to :user
  has_many :bookings

  enum room_type: [ :entire_home, :private_room, :shared_room ]

  mount_uploaders :photos, ListingPhotoUploader

  def one_photo_required
    unless self.photos?
      errors.add(:photos, "can't be empty")
      return false
    end
  end
end
