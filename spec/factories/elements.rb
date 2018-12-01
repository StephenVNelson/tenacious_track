FactoryBot.define do
  factory :element do
    element_category { ElementCategory.where(category_name: 'Body Position').first_or_create!  }
    sequence(:name) {|n| "element_#{n}"}

    factory :element_angle do
      element_category { ElementCategory.where(category_name: 'Angle').first_or_create! }
    end
  end
end
