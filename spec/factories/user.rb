FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    full_name "Testy McTest Face"
  end
end
