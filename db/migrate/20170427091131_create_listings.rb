class CreateListings < ActiveRecord::Migration[5.0]
  def change
    create_table :listings do |t|
      t.string :name, null: false
      t.integer :user_id, null: false
      t.string :description
      t.decimal :price, null: false
      t.string :address, null: false
      t.integer :room_count, null: false
      t.integer :bed_count, null: false
      t.integer :guest_count, null: false
      t.timestamps
    end
  end
end
