require 'csv'

csv_text = File.read(Rails.root.join('lib', 'seeds', 'ElementCategories.csv'))
csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
csv.each do |row|
  t = ElementCategory.new
  t.category_name = row['category_name']
  t.sort = row['sort']
  t.save
  puts "#{t.category_name} saved"
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
