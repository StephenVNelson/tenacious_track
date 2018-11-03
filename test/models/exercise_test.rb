require 'test_helper'

class ExerciseTest < ActiveSupport::TestCase
  def setup
    @exercise = Exercise.new(reps_bool: true)
    @exercise.elements << Element.first
    @exercise_one = exercises(:one)
    @element1 = elements(:one)
    @element2 = elements(:two)
  end

  test "exercise is valid" do
    assert @exercise.valid?
  end

  test "exercise elements present" do
    @exercise_one.elements.clear
    @exercise_one.elements << Element.limit(2)
    assert @exercise_one.elements.count > 0
  end

  test "duplicate exercise not valid" do
    new_exercise_01 = Exercise.new(
      reps_bool: true,
      exercise_elements_attributes: [
        {element_id: Element.find_by(name: "Prone").id},
        {element_id: Element.find_by(name: "Incline").id}
        ]
      )
    new_exercise_02 = Exercise.new(
      reps_bool: true,
      exercise_elements_attributes: [
        {element_id: @element1.id},
        {element_id: @element2.id}
        ]
      )
    assert new_exercise_01.valid?
    assert new_exercise_02.valid?
    new_exercise_01.save
    assert_not new_exercise_01.valid?
    assert_not new_exercise_02.valid?
  end

  test "exercise without measurement not valid" do
    new_exercise = Exercise.new(reps_bool: false,
    exercise_elements_attributes: [
      {element_id: Element.find_by(name: "Incline").id},
      {element_id: Element.find_by(name: "Prone").id}
      ]
    )
    assert_not new_exercise.valid?
  end



end
