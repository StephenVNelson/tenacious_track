User.create!(name:  "Stephen Nelson",
             email: "mituseye@gmail.com",
             password:              "password",
             password_confirmation: "password",
             hire_date: Date.today, admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  hire_date = Faker::Time.between((365*4).days.ago, Time.now, :midnight).to_date
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               hire_date: hire_date)
end
