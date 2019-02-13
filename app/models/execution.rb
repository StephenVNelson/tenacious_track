class Execution < ApplicationRecord
  belongs_to :exercise
  belongs_to :workout
  belongs_to :execution_category
end
