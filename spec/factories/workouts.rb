FactoryBot.define do
  factory :workout do
    trainer_id { 1 }
    client { "" }
    scheduled_date { "2019-01-24" }
    logged_date { "2019-01-24 17:18:47" }
    phase_number { 1 }
    week_number { 1 }
    day_number { 1 }
    workout_focus { "MyString" }
    sets { 1 }
    reps { 1 }
    resistance { "MyString" }
    duration_min { 1 }
    duration_sec { 1 }
  end
end
