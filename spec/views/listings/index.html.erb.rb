require 'rails_helper'

RSpec.describe "listings/index.html.erb", type: :feature do
  before do
    75.times do
      FactoryGirl.create(:listing)
    end
  end

  context "pagination" do

    it "should only have a next link on the first page" do
      visit "/listings?page=1"
      expect(page.has_link?("Previous")).to be(false)
      expect(page.has_link?("Next")).to be(true)
    end

    it "should have a next and previous link on middle pages" do
      visit "/listings?page=2"
      expect(page.has_link?("Previous")).to be(true)
      expect(page.has_link?("Next")).to be(true)
    end

    it "should only have a previous link on the last page" do
      visit "/listings?page=3"
      expect(page.has_link?("Previous")).to be(true)
      expect(page.has_link?("Next")).to be(false)
    end

    it "should display the current page number" do
      visit "/listings?page=3"
      expect(page.has_content?("75 results")).to be(true)
    end

    it "should display the total number of results" do
      visit "/listings?page=3"
      expect(page.has_content?("Page 3")).to be(true)
    end
  end
end
