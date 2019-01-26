FactoryBot.define do
  factory :workout do
    trainer
    client
    scheduled_date { "2019-01-24" }
    logged_date { "2019-01-24 17:18:47" }
    phase_number { rand(1..8) }
    week_number { rand(1..4) }
    day_number { rand(1..2) }
    workout_focus { "MyString" }
  end
end
