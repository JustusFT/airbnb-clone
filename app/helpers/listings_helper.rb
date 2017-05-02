module ListingsHelper
  def amenities_array
    [:"heating", :"kitchen", :"tv", :"wireless_internet", :"air_conditioning", :"breakfast", :"buzzer/wireless_intercom", :"doorman", :"dryer", :"family/kid_friendly", :"hair_dryer", :"hangers", :"indoor_fireplace", :"iron", :"laptop_friendly_workspace", :"lock_on_bedroom_door", :"self_check-in", :"shampoo", :"washer"]
  end

  def room_type_collection
    Listing.room_types.keys.map { |w| [w.humanize, w] }
  end
end
