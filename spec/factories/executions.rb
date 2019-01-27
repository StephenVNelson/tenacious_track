FactoryBot.define do
  factory :execution do
    exercise_id { nil }
    workout_id { nil }
    sets { 1 }
    reps { 1 }
    resistance { "MyString" }
    seconds { 1 }
  end
end
