# Create ourselves!
puts "Destroying previous seeds"
Booking.destroy_all
Kondo.destroy_all
User.destroy_all
puts "Previous seeds destroyed!"

# User
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

# Cédrine users: provider as cedrine@email.com, renter as rcedrine@email.com
user3 = create_user("Cedrine Monnet", "provider")
user4 = create_user("Cedrine Monnet", "renter")

# Carl's users: provider as carl@email.com, renter as rcarl@email.com
user5 = create_user("Carl Noval", "provider")
user6 = create_user("Carl Noval", "renter")

# Shante's users: provider as shante@email.com, renter as rshante@email.com
user7 = create_user("Shante Johnson", "provider")
user8 = create_user("Shante Johnson", "renter")
puts "User creation done!"

#Creating new users
# Kondo names, summary, and details
 name_summary_details =
   [["Commerical Interior Designer ", "Designing interior spaces to be functional to conduct business efficiently."," A professional who can create and direct the construction of these commercial spaces. Guides clients to select materials, colors, and furnishings that align with the company’s brand and aesthetic. Arranges the layout of interior walls and the use of spaces. Finally, directs and coordinates the work among the professionals working on the construction project."],
  ["Space Planning Interior Designer", "Space planning is everything! Find your home design nirvana today.", "Space planning is a fundamental element of the interior design process. It starts with an in-depth analysis of how the space is to be used. The designer then draws up a plan that defines the zones of the space and the activities that will take place in those zones. The space plan will also define the circulation patterns that show how people will move through the space.  The plan is finished by adding details of all the furniture, equipment and hardware placement."],
    ["Minimalist Interior Designer", "Live lavishly without the clutter.", "Minimalist interior design is very similar to modern interior design and involves using the bare essentials to create a simple and uncluttered space. It’s characterised by simplicity, clean lines, and a monochromatic palette with colour used as an accent."],
    ["Professional Housekeeper", "Providing a professional service to keep your home clean and tidy.", "A professional housekeeper who is trained to maintain the cleanliness and order of a home. Responsible for cleaning and maintaining the house, and services can include maintenance of the house’s electrical system, plumbing, and other appliances."],
   ["Industrial Housekeeping", "Aimed to provide excellent quality services", "Part of our job is to inform our customers and users about the potential problems and health hazards that may arise if the equipment is not used or maintained properly, or if there is not a working strategy in place for making sure that the work environment is safe. If the facility and the machines are dusty and dirty, the quality of what is being manufactured is likely to be affected as well. A clean, well-kept work environment might also very well make a company more attractive to customers as well as existing and potential employees."]]


# Some kondos for provider users
puts "Creating kondos"


10.times do
  services = name_summary_details.sample
  kondos = Kondo.new(
              name: services[0],
              summary: services[1],
              details: services[2],
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
