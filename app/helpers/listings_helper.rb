module ListingsHelper
  def room_type_collection
    Listing.room_types.keys.map { |w| [w.humanize, w] }
  end
end
