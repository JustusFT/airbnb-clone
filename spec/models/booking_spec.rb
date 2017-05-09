require 'rails_helper'

RSpec.describe Booking, type: :model do
  let(:booking) {FactoryGirl.create(:booking)}

  context "associations" do
    it "belongs to a user" do
      expect(booking.user).to be_a_kind_of(User)
    end

    it "belongs to a listing" do
      expect(booking.listing).to be_a_kind_of(Listing)
    end
  end

  context "validations" do
    it "should have check_in present and as a date type" do
      expect(booking.check_in).to be_a_kind_of(Date)
    end

    it "should have check_out present and as a date type" do
      expect(booking.check_out).to be_a_kind_of(Date)
    end

    it "should not overlap with other bookings" do
      booking_a = FactoryGirl.create(
        :booking,
        check_in: Date.parse("2200-01-01"),
        check_out: Date.parse("2200-01-07")
      )
      expect { FactoryGirl.create(
        :booking,
        listing_id: booking_a.listing.id,
        check_in: Date.parse("2200-01-04"),
        check_out: Date.parse("2200-01-11")
      ) }.to raise_error
    end

    it "should only allow future dates" do
      expect { FactoryGirl.create(:booking, check_in: "2000-01-01") }.to raise_error
      expect(booking).to be_valid
    end

    it "should have the check_in date before the check_out date" do
      expect(booking.check_in < booking.check_out).to be(true)
    end
  end
end
