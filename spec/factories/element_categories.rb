FactoryBot.define do
  factory :element_category do
    category_name {"Body Position"}
    sequence(:sort)

    factory :angle do
      category_name {"Angle"}
    end
  end
end
