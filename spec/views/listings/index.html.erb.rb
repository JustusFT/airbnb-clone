describe "listings#index", :type => :feature do
  # before :each do
    
  # end

  context "pagination" do
    it "should not have a previous link on the first page"
    it "should not have a next link on the first page"
    it "should display the current page number"
  end

  context "new listing link" do
    it "redirects to listings/new if the user is logged in"
    it "redirects to login page if the user is logged out"
  end
end
