# db/seeds.rb
require "securerandom"

# ------------------------------
# Create Admin User
# ------------------------------
admin = User.find_or_create_by!(email: 'admin@example.com') do |u|
  u.password = 'supersecurepassword'
  u.password_confirmation = 'supersecurepassword'
end

# Assign admin role
admin.add_role :admin

# ------------------------------
# Clear Existing Data
# ------------------------------
Car.destroy_all
Model.destroy_all
Make.destroy_all

# ------------------------------
# Seed Makes and Models
# ------------------------------
makes_with_models = {
  "Toyota" => [ "Corolla", "Camry", "RAV4" ],
  "Honda" => [ "Civic", "Accord", "CR-V" ],
  "Ford" => [ "Focus", "Mustang", "Explorer" ],
  "BMW" => [ "3 Series", "5 Series", "X5" ],
  "Mercedes-Benz" => [ "C-Class", "E-Class", "GLA" ],
  "Audi" => [ "A3", "A4", "Q5" ],
  "Nissan" => [ "Altima", "Sentra", "Rogue" ],
  "Chevrolet" => [ "Malibu", "Impala", "Equinox" ],
  "Hyundai" => [ "Elantra", "Sonata", "Tucson" ],
  "Kia" => [ "Forte", "Optima", "Sportage" ],
  "Volkswagen" => [ "Golf", "Passat", "Tiguan" ],
  "Subaru" => [ "Impreza", "Legacy", "Forester" ]
}

body_styles = [ "Sedan", "Hatchback", "SUV", "Coupe" ]
transmissions = [ "Automatic", "Manual" ]
fuel_types = [ "Petrol", "Diesel", "Hybrid", "Electric" ]
colors = [ "White", "Black", "Silver", "Blue", "Red", "Gray" ]

# List of image filenames
image_files = (1..18).map { |i| Rails.root.join("db/seeds/images/car#{i}.jpg") }

makes_with_models.each do |make_name, model_names|
  make = Make.create!(name: make_name)

  model_names.each do |model_name|
    model = Model.create!(name: model_name, make: make)

    2.times do
      car = Car.new(
        make: make,
        model: model,
        user: admin,
        year: rand(2010..2023),
        price: rand(8000..50000),
        mileage: rand(5000..150000),
        condition: [ "brand_new", "used" ].sample,
        status: [ "in_stock", "sold" ].sample,
        body_style: body_styles.sample,
        transmission: transmissions.sample,
        fuel_type: fuel_types.sample,
        color: colors.sample,
        description: "A well-maintained #{make_name} #{model_name} with excellent performance and comfort.",
        published_at: [ nil, Time.now - rand(1..365).days ].sample
      )

      # Attach 1–3 random local images
      rand(1..3).times do
        image_file = image_files.sample
        car.images.attach(
          io: File.open(image_file),
          filename: "car_#{SecureRandom.hex(4)}.jpeg",
          content_type: "image/jpeg"
        )
      end

      # Generate slug explicitly before saving
      car.generate_slug

      # Save after attaching images and generating slug
      car.save!
    end
  end
end

puts "Seeded #{Make.count} makes, #{Model.count} models, and #{Car.count} cars with images and slugs."
