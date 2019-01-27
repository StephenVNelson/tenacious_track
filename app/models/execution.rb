class Execution < ApplicationRecord
  belongs_to :exercise
  belongs_to :workout

  validates :exercise_id, presence: {message: "Execution must include an exericise"}
  validates :workout_id, presence: {message: "Execution must include a workout"}
end
