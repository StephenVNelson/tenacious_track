FactoryBot.define do
  factory :execution_category do
    sequence(:name) {|n| "Category_#{n}"}
  end
end
