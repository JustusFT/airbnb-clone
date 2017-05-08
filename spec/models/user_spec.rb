require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user)    {FactoryGirl.create(:user)}
  let!(:listing) {FactoryGirl.create(:listing, user_id: user.id)}
  let!(:booking) {FactoryGirl.create(:booking, user_id: user.id)}

  context "associations" do
    it "has many listings" do
      expect(user.listings.first).to be_a_kind_of(Listing)
    end

    it "has many bookings" do
      expect(user.bookings.first).to be_a_kind_of(Booking)
    end
  end

  it "have 3 authority levels" do
    expect(FactoryGirl.create(:user, role: 0).role).to eq("customer")
    expect(FactoryGirl.create(:user, role: 1).role).to eq("moderator")
    expect(FactoryGirl.create(:user, role: 2).role).to eq("admin")
  end
end
