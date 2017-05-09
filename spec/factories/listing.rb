FactoryGirl.define do
  factory :listing do
    user
    name {Faker::App.name}
    room_count {rand(0..5)}
    bed_count {rand(1..6)}
    guest_count {rand(1..10)}
    room_type {rand(0..2)}

    address {Faker::Address.street_address}

    price {rand(80..500)}
    description {Faker::Hipster.sentence}

    photos {[File.new("#{Rails.root}/public/640x480.png")]}
  end
end
