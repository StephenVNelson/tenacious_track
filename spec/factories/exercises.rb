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

    trait :with_3_elements do
      after(:create) do |exercise|
        create_list(:exercise_element, 2, exercise: exercise)
        # element1 = Element.find_by(name: "element_1") || FactoryBot.create(:element, name: "element_1")
        # exercise.elements << element1 if !exercise.elements.include?(element1)
      end
    end

  end
end
