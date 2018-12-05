require 'rails_helper'

RSpec.describe ExerciseElement, type: :model do

  it "has a working factory" do
    exercise_element = build(:exercise_element)
    expect(exercise_element).to be_valid
  end

  it "is invalid if exercise and element aren't unique" do
    element = create(:element)
    exercise = create(:exercise)
    create(:exercise_element, element: element, exercise: exercise)
    exercise_element = build(:exercise_element,
      element: element,
      exercise: exercise
    )
    exercise_element.valid?
    expect(exercise_element.errors[:exercise_id]).to include("has already been taken")
  end

  it "has an exercise and an element" do
    exercise_element = build(:exercise_element)
    expect(exercise_element.exercise).to be_kind_of(Exercise)
    expect(exercise_element.element).to be_kind_of(Element)
  end


end
