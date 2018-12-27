FactoryBot.define do
  factory :element do
    element_category { ElementCategory.where(category_name: 'Body Position').first || create(:element_category) }
    sequence(:name) {|n| "element_#{n}"}

    factory :element_angle do
      element_category { ElementCategory.where(category_name: 'Angle').first || create(:angle)}
    end
    factory :element_body_position do
      element_category { ElementCategory.where(category_name: 'Body Position').first || create(:body_position)}
    end
  end
end
