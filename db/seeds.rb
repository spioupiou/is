# Create ourselves!
puts "Destroying previous seeds"
Booking.destroy_all
Kondo.destroy_all
User.destroy_all
puts "previous seeds destroyed!"

# User

puts "Creating Users"
user1 = User.create!(
            first_name: "Hiro",
            last_name: "Takemura",
            email: "hiro@email.com",
            password: "123456"
)
user2 = User.create!(
            first_name: "Cedrine",
            last_name: "Monnet",
            email: "cedrine@email.com",
            password: "123456"
)
user3 = User.create!(
            first_name: "Carl",
            last_name: "Noval",
            email: "carl@email.com",
            password: "123456"
)
user4 = User.create!(
            first_name: "Shante",
            last_name: "Johnson",
            email: "shante@email.com",
            password: "123456"
)
puts "User creation done!"

# Some kondos

puts "Creating kondos"

20.times do
  kondos = Kondo.new(
              name: ["Interior Designer","House Keeping", "Home Destroyer", "Thief"].sample,
              summary: Faker::Lorem.sentence(word_count: 20, supplemental: true, random_words_to_add: 10),
              details: Faker::Lorem.sentence(word_count: 50, supplemental: true, random_words_to_add: 50),
              prefecture: ["Tokyo", "Kanagawa", "Chiba", "Saitama", "Ibaraki", "Tochigi", "Yamanashi"].sample,
              price: ((rand(5..20)) * 1000),
              user_id: [user1, user2, user3, user4].sample.id
              )
  kondos.save!
end

puts "Kondos Creation done!"

puts "Creating bookings"

kondos = Kondo.all

10.times do
  bookings = Booking.new(
    user_id: [user1, user2, user3, user4].sample.id,
    kondo_id: kondos.sample.id,
    confirmed: false,
    booked_date: Time.now
  )
  bookings.save!
end

puts "Bookings Creation done!"
