class ExerciseElement < ApplicationRecord

  validates :exercise_id, uniqueness: {scope: :element_id}

  belongs_to :exercise
  belongs_to :element
end
