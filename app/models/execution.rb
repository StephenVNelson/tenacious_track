class Execution < ApplicationRecord
  belongs_to :exercise
  belongs_to :workout
  belongs_to :execution_category


  scope :category, ->(category) {joins(:execution_category).where(execution_categories: {name: category})}
end
