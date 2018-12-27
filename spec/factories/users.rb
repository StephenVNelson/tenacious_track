FactoryBot.define do
  factory :user do
    name {Faker::Name.name}
    email {Faker::Internet.email}
    password {"password"}
    password_digest {User.digest('password')}
    hire_date {Date.today}
    activated {true}
    activated_at {Time.zone.now}

    factory :admin do
      admin {true}
    end

  end
end
