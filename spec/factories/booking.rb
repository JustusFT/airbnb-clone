FactoryGirl.define do
  factory :booking do
    user
    listing
    check_in { Date.parse("2100-01-01") }
    check_out { Date.parse("2100-01-02") }
  end
end
