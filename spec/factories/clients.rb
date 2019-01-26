FactoryBot.define do
  factory :client do
    name {Faker::Name.name}
    email {Faker::Internet.email}
    weekly_committment { rand(1..2) }
    phone { Faker::PhoneNumber.subscriber_number(10) }
  end
end
