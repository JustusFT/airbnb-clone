class Listing < ApplicationRecord
  validates_presence_of :user_id, :price, :address, :room_count, :bed_count, :guest_count
  acts_as_taggable
  belongs_to :user
  has_many :bookings
end
