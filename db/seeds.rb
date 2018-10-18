require 'csv'

categories = File.read(Rails.root.join('lib', 'seeds', 'Categories.csv'))
parse_categories = CSV.parse(categories, :headers => true, :encoding => 'ISO-8859-1')
parse_categories.each do |row|
  t = ElementCategory.new
  t.category_name = row['category_name']
  t.save
  puts "#{t.category_name} saved"
end

elements = File.read(Rails.root.join('lib', 'seeds', 'Elements.csv'))
parse_elements = CSV.parse(elements, :headers => true, :encoding => 'ISO-8859-1')
parse_elements.each do |row|
  t = Element.new
  t.name = row['name']
  t.element_category_id = row['element_category_id']
  t.save
  puts "#{t.name} saved"
end


User.create!(name:  "Stephen Nelson",
             email: "mituseye@gmail.com",
             password:              "password",
             password_confirmation: "password",
             hire_date: Date.today, admin: true, activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "Sean McCawley",
            email: "napatenacious@gmail.com",
            password:              "password",
            password_confirmation: "password",
            hire_date: Date.today, admin: true, activated: true,
            activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  hire_date = Faker::Time.between((365*4).days.ago, Time.now, :midnight).to_date
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               hire_date: hire_date, activated: true,
              activated_at: Time.zone.now)
end
