FactoryBot.define do
  factory :exercise do
    # :elements
    reps_bool {true}
    resistance_bool {Faker::Boolean.boolean}
    duration_bool {Faker::Boolean.boolean}
    work_rest_bool {Faker::Boolean.boolean}
    gif_link {nil}

    factory :exercise_with_element do      
      after(:build) do |exercise|
        exercise.elements << build(:element)
      end
    end

  end
end
