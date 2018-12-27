FactoryBot.define do
  factory :element_category do
    sequence(:category_name) {|n| "Category_#{n}"}
    sequence(:sort)

    factory :angle do
      category_name {"Angle"}
    end

    factory :body_position do
      category_name {"Body Position"}
    end

    factory :invalid_category do
      category_name {nil}
    end
  end
end
