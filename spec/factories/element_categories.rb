FactoryBot.define do
  factory :element_category do
    category_name {"Body Position"}
    sequence(:sort)

    factory :angle do
      category_name {"Angle"}
    end

    factory :body_position do
      category_name {"Body Position"}
    end
  end
end
