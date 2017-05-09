require 'rails_helper'

RSpec.describe BookingsController, type: :controller do
  before do
    listing = FactoryGirl.create(:listing)
    booking = FactoryGirl.create(:booking)
    user = FactoryGirl.create(:user)
    controller.stub(:current_user){ user }
    controller.stub(:signed_in?){ true }
    post :create, params: { listing_id: listing.id, booking: {listing_id: listing.id, check_in: booking.check_in, check_out: booking.check_out} }
    get :new, params: { listing_id: listing.id }
  end

  describe "GET #new" do
    it "redirects to login page if the user is logged out" do
      controller.stub(:signed_in?){ false }
      listing = FactoryGirl.create(:listing)
      get :new, params: { listing_id: listing.id }
      expect(response).to redirect_to("/sign_in")
    end

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "renders the new template" do
      expect(response).to render_template("new")
    end

    it "assigns instance booking" do
      expect(assigns[:booking]).to be_a Booking
    end
  end

  describe "POST #create" do
    # happy_path
    context "valid_params" do
      # before do
      #   listing = FactoryGirl.create(:listing)
      # end

      it "creates new booking if params are correct" do
        listing = FactoryGirl.create(:listing)
        expect {post :create, params: {listing_id: listing.id, :booking => FactoryGirl.create(:booking).as_json}}.to change(Booking, :count).by(1)
      end

      it 'redirects to braintree#new after user created successfully' do
        listing = FactoryGirl.create(:listing)
        post :create, params: {listing_id: listing.id, :booking => FactoryGirl.create(:booking).as_json}
        expect(response).to redirect_to("/braintree/new")
      end
    end

    # unhappy_path
    context "invalid_params" do
      # before do
      #   post :create, user: FactoryGirl.create(:user, email: "not_valid")
      # end

      it "displays flash alert message" do
        listing = FactoryGirl.create(:listing)
        invalid_booking = FactoryGirl.create(:booking)
        invalid_booking.check_in = nil
        post :create, params: {listing_id: listing.id, booking: invalid_booking.as_json}
        expect(flash[:alert]).not_to be(nil)
      end

      it "renders new template again" do
        listing = FactoryGirl.create(:listing)
        invalid_booking = FactoryGirl.create(:booking)
        invalid_booking.check_in = nil
        post :create, params: {listing_id: listing.id, booking: invalid_booking.as_json}
        expect(response).to render_template("new")
      end
    end
  end
end
