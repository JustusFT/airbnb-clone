class Listing < ApplicationRecord
  validates_presence_of :user_id, :price, :address, :room_count, :bed_count, :guest_count
end
