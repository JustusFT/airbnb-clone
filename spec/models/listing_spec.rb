require 'rails_helper'

RSpec.describe Listing, type: :model do
  let(:booking) {FactoryGirl.create(:booking)}
  let(:listing) {booking.listing}

  context "associations" do
    it "belongs to a user" do
      expect(listing.user).to be_a_kind_of(User)
    end

    it "has many bookings" do
      expect(listing.bookings.first).to be_a_kind_of(Booking)
    end
  end

  context "validations" do
    it "should have a presence of these set: :user_id, :price, :address, :room_count, :bed_count, :guest_count" do
      expect{FactoryGirl.create(:listing, user_id: nil)}.to raise_error
      expect{FactoryGirl.create(:listing, price: nil)}.to raise_error
      expect{FactoryGirl.create(:listing, address: nil)}.to raise_error
      expect{FactoryGirl.create(:listing, room_count: nil)}.to raise_error
      expect{FactoryGirl.create(:listing, bed_count: nil)}.to raise_error
      expect{FactoryGirl.create(:listing, guest_count: nil)}.to raise_error
    end

    it "should have at least one photo" do
      expect{FactoryGirl.create(:booking, photos: nil)}.to raise_error
    end
  end

  it "has a room type for :entire_home, :private_room, :shared_room" do
    expect(FactoryGirl.create(:listing, room_type: 0).room_type).to eq("entire_home")
    expect(FactoryGirl.create(:listing, room_type: 1).room_type).to eq("private_room")
    expect(FactoryGirl.create(:listing, room_type: 2).room_type).to eq("shared_room")
  end
end
