class ExerciseElement < ApplicationRecord

  validates :exercise_id, uniqueness: {scope: :element_id}
  # validate :exercise_elements_combinations

  belongs_to :exercise
  belongs_to :element

  def exercise_elements_combinations
    exercises = Exercise.all.map(&:elements)
    current_exercise = Exercise.find(self.exercise_id)
    exercise_elements = current_exercise.elements.to_a
    element_to_add = Element.find(self.element_id)
    new_elements = exercise_elements.insert(-1, element_to_add)
    # binding.pry if Exercise.count >= 2 && current_exercise == Exercise.first
    if exercises.include?(new_elements)
      puts "TRIGGERED!!!!"
      errors[:base] << "Exercise already exists, consider adding different elements"
    end
  end
end
