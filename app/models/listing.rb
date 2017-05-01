class Listing < ApplicationRecord
  validates_presence_of :user_id, :price, :address, :room_count, :bed_count, :guest_count
  validate :one_photo_required
  before_create :one_photo_required
  acts_as_taggable
  acts_as_taggable_on :amenities
  belongs_to :user
  has_many :bookings

  mount_uploaders :photos, ListingPhotoUploader

  def one_photo_required
    unless self.photos?
      errors.add(:photos, "can't be empty")
      return false
    end
  end
end
