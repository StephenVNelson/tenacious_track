FactoryBot.define do
  factory :exercise do
    reps_bool {Faker::Boolean.boolean}
    resistance_bool {Faker::Boolean.boolean}
    duration_bool {Faker::Boolean.boolean}
    work_rest_bool {Faker::Boolean.boolean}
    gif_link {nil}
  end
end
