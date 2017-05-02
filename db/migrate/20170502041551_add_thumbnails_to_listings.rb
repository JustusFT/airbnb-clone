class AddThumbnailsToListings < ActiveRecord::Migration[5.0]
  def change
    add_column :listings, :thumbnails, :json
  end
end
