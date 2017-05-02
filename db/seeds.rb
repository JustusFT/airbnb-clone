# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Seed Users

user = {}
user['password'] = 'asdf'
user['password_confirmation'] = 'asdf'

ActiveRecord::Base.transaction do
  1.times do
    user['full_name'] = Faker::Name.first_name
    user['email'] = Faker::Internet.email
    u = User.new(user)
    i = MiniMagick::Image.open(Faker::Avatar.image)
    i.resize("128x128")
    u.avatar = i
    u.save!
  end
end

# Seed Listings
listing = {}
uids = []
User.all.each { |u| uids << u.id }

ActiveRecord::Base.transaction do
  1.times do
    listing['name'] = Faker::App.name
    listing['room_count'] = rand(0..5)
    listing['bed_count'] = rand(1..6)
    listing['guest_count'] = rand(1..10)
    listing['room_type'] = rand(0..2)

    listing['address'] = Faker::Address.street_address

    listing['price'] = rand(80..500)
    listing['description'] = Faker::Hipster.sentence

    listing['user_id'] = uids.sample

    l = Listing.new(listing)

    random_photos = []
    thumbnails = []
    2.times do
      # the thumbnail and images don't match. whatever, this is just for testing purposes anyway
      url = Faker::LoremPixel.image
      i = MiniMagick::Image.open(url)
      t = MiniMagick::Image.open(url)
      t.resize("640x480")
      random_photos << i
      thumbnails << t
    end
    p random_photos
    l.photos = random_photos
    l.thumbnails = thumbnails

    l.save!
  end
end
