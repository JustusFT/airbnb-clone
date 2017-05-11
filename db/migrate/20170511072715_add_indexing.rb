class AddIndexing < ActiveRecord::Migration[5.0]
  def change
    add_index :bookings, :user_id
    add_index :bookings, :listing_id
    add_index :listings, :user_id
  end
end
