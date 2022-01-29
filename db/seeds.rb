# Create ourselves!
puts "Destroying previous seeds"
Booking.destroy_all
Kondo.destroy_all
User.destroy_all
puts "Previous seeds destroyed!"

# User creation

# Pics collections for Users
female_pics = [
  'https://res.cloudinary.com/djlvhfuba/image/upload/v1643426257/development/female1_qxmdm6.jpg',
  'https://res.cloudinary.com/djlvhfuba/image/upload/v1643426257/development/female2_nxng2s.jpg',
  'https://res.cloudinary.com/djlvhfuba/image/upload/v1643426256/development/female3_gdh15y.jpg',
  'https://res.cloudinary.com/djlvhfuba/image/upload/v1643426255/development/female4_o8mpsf.jpg',
  'https://res.cloudinary.com/djlvhfuba/image/upload/v1643426254/development/female5_p78d7p.jpg'
]

male_pics = [
  'https://res.cloudinary.com/djlvhfuba/image/upload/v1643426256/development/male1_udy20m.jpg',
  'https://res.cloudinary.com/djlvhfuba/image/upload/v1643426254/development/male2_jijizi.jpg',
  'https://res.cloudinary.com/djlvhfuba/image/upload/v1643426254/development/male3_iberut.jpg',
  'https://res.cloudinary.com/djlvhfuba/image/upload/v1643426254/development/male4_htj2ua.jpg',
  'https://res.cloudinary.com/djlvhfuba/image/upload/v1643426255/development/male5_ekvwyw.jpg'
]

def create_user(full_name, role)
  User.create!(
    first_name: full_name.split.first,
    last_name: full_name.split.last,
    email: "#{'r' if role == 'renter'}#{full_name.split.first.downcase}@email.com",
    password: "123456",
    role: role,
    prefecture: ["Tokyo", "Chiba", "Tochigi", "Yamaguchi"].sample
  )
end

puts "Creating Users"

# Hiro's users: provider as hiro@email.com, renter as rhiro@email.com
user1 = create_user("Hiro Takemura", "provider")
user2 = create_user("Hiro Takemura", "renter")

# Carl's users: provider as carl@email.com, renter as rcarl@email.com
user3 = create_user("Carl Noval", "provider")
user4 = create_user("Carl Noval", "renter")

male_users = [user1, user2, user3, user4]
male_users.each do |user|
  user.photo.attach(io: URI.open(male_pics.sample), filename: 'user.jpg')
  user.save!
end

# Cédrine users: provider as cedrine@email.com, renter as rcedrine@email.com
user5 = create_user("Cedrine Monnet", "provider")
user6 = create_user("Cedrine Monnet", "renter")

# Shante's users: provider as shante@email.com, renter as rshante@email.com
user7 = create_user("Shante Johnson", "provider")
user8 = create_user("Shante Johnson", "renter")

female_users = [user5, user6, user7, user8]
female_users.each do |user|
  user.photo.attach(io: URI.open(female_pics.sample), filename: 'user.jpg')
  user.save!
end

puts "User creation done!"

# Some kondos for provider users
puts "Creating kondos"

20.times do
  kondos = Kondo.new(
    name: ["Interior Designer","House Keeping"].sample,
    summary: Faker::Lorem.sentence(word_count: 20, supplemental: true, random_words_to_add: 10),
    details: Faker::Lorem.sentence(word_count: 50, supplemental: true, random_words_to_add: 50),
    prefecture: ["Tokyo", "Kanagawa", "Chiba", "Saitama", "Ibaraki", "Tochigi", "Yamanashi"].sample,
    price: ((rand(5..20)) * 1000),
    service_duration: rand(1..7),
    user_id: [user1, user3, user5, user7].sample.id
  )
  kondos.save!
end

puts "Kondos Creation done!"

puts "Creating bookings"

kondos = Kondo.all

10.times do
  bookings = Booking.new(
    user_id: [user2, user4, user6, user8].sample.id,
    kondo_id: kondos.sample.id,
    status: ["waiting", "confirmed", "declined", "completed"].sample,
    booked_date: Time.now + 3.days
  )
  bookings.save!
end

puts "Bookings Creation done!"
