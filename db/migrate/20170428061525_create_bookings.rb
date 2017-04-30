class CreateBookings < ActiveRecord::Migration[5.0]
  def change
    create_table :bookings do |t|
      t.integer :user_id, null: false
      t.integer :listing_id, null: false
      t.date :check_in, null: false
      t.date :check_out, null: false
    end
    add_foreign_key :bookings, :users
    add_foreign_key :bookings, :listings
  end
end
