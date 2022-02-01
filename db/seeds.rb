# Create ourselves!
puts "Destroying previous seeds"
Review.destroy_all
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

#Creating new users
# Kondo names, summary, and details
name_summary_details = [
  ["Commercial Interior Designer", "Designing interior spaces to be functional to conduct business efficiently."," A professional who can create and direct the construction of these commercial spaces. Guides clients to select materials, colors, and furnishings that align with the company’s brand and aesthetic. Arranges the layout of interior walls and the use of spaces. Finally, directs and coordinates the work among the professionals working on the construction project."],
  ["Space Planning Interior Designer", "Space planning is everything! Find your home design nirvana today.", "Space planning is a fundamental element of the interior design process. It starts with an in-depth analysis of how the space is to be used. The designer then draws up a plan that defines the zones of the space and the activities that will take place in those zones. The space plan will also define the circulation patterns that show how people will move through the space.  The plan is finished by adding details of all the furniture, equipment and hardware placement."],
  ["Minimalist Interior Designer", "Live lavishly without the clutter.", "Minimalist interior design is very similar to modern interior design and involves using the bare essentials to create a simple and uncluttered space. It’s characterised by simplicity, clean lines, and a monochromatic palette with colour used as an accent."],
  ["Professional Housekeeper", "Providing a professional service to keep your home clean and tidy.", "A professional housekeeper who is trained to maintain the cleanliness and order of a home. Responsible for cleaning and maintaining the house, and services can include maintenance of the house’s electrical system, plumbing, and other appliances."],
  ["Industrial Housekeeping", "Aimed to provide excellent quality services", "Part of our job is to inform our customers and users about the potential problems and health hazards that may arise if the equipment is not used or maintained properly, or if there is not a working strategy in place for making sure that the work environment is safe. If the facility and the machines are dusty and dirty, the quality of what is being manufactured is likely to be affected as well. A clean, well-kept work environment might also very well make a company more attractive to customers as well as existing and potential employees."]
]


# Some kondos for provider users
puts "Creating kondos"


10.times do
  services = name_summary_details.sample
  kondos = Kondo.new(
    name: services[0],
    summary: services[1],
    details: services[2],
    prefecture: %w[Aichi Akita Aomori Chiba Ehime Fukui Fukuoka Fukushima Gifu Gunma Hiroshima Hokkaido Hyogo Ibaraki Ishikawa Iwate Kagawa Kagoshima Kanagawa Kochi Kumamoto Kyoto Mie Miyagi Miyazaki Nagano Nagasaki Nara Niigata Okayama Okinawa Oita Osaka Saga Saitama Shiga Shimane Shizuoka Tochigi Tokushima Tokyo Tottori Toyama Wakayama Yamagata Yamaguchi Yamanashi].sample,
    price: ((rand(5..20)) * 1000),
    service_duration: rand(1..7),
    user_id: [user1, user3, user5, user7].sample.id
  )

  kondos.save!
end

puts "Kondos Creation done!"

puts "Creating bookings"

kondos = Kondo.all

20.times do
  bookings = Booking.new(
    user_id: [user2, user4, user6, user8].sample.id,
    kondo_id: kondos.sample.id,
    status: ["waiting", "confirmed", "declined", "completed"].sample,
    booked_date: Time.now + 3.days
  )
  bookings.save!
end

puts "Bookings Creation done!"

bookings = Booking.all

bad_reviews = [
  "The designer was not very pleasant...", "Too expensive, wouldn't recommend",
  "Showed up 1 hour late", "Did the job but was expecting more", "Too pricey"
]

good_reviews = [
  "The designer did an awesome job!", "My house looks so much better now thanks to IS Kondo",
  "100% would do it again", "My bedroom looks brand-new!", "I love the dedication my designed put in renovating the house",
  "I have introduced this service to all my friends, it's just so good!", "Amazing job", "Great service!!"
]

5.times do
  Review.create!(
    rating: rand(0..2),
    comment: bad_reviews.sample,
    booking_id: bookings.sample.id,
    user_id: [user1, user3, user5, user7].sample.id # only providers
  )
end

25.times do
  Review.create!(
    rating: rand(3..5),
    comment: good_reviews.sample,
    booking_id: bookings.sample.id,
    user_id: [user1, user3, user5, user7].sample.id # only providers
  )
end
