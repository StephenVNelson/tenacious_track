require 'test_helper'

class ExercisesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @exercise = exercises(:one)
    @element1 = elements(:one)
    @element2 = elements(:two)
  end

  test "should get index" do
    get exercises_url
    assert_response :success
  end

  test "should get new" do
    get new_exercise_url
    assert_response :success
  end

  test "should create exercise" do
    assert_difference('Exercise.count') do
      post exercises_path, params: {
        exercise: {
          reps_bool: true,
          exercise_elements_attributes: {"0": {element_id: @element1.id.to_s},
                                        "1": {element_id: @element2.id.to_s}
          }
        }
      }
    end
    assert_redirected_to exercises_path
  end

  test "should create exercise when submitted through multiselect" do
    assert_difference('Exercise.count') do
      post exercises_path, params: {
        exercise: {
          reps_bool: true,
          exercise_elements_attributes:
            {"0":
              {element_id: ["" ,@element1.id.to_s, @element2.id.to_s]}
          }
        }
      }
    end
    assert_redirected_to exercises_path
  end

  test "should show exercise" do
    get exercise_url(@exercise)
    assert_response :success
  end

  test "should get edit" do
    get edit_exercise_url(@exercise)
    assert_response :success
  end

  # TODO: Add these fake params tests to Exercise.rb and add the code snippet that Gino send you over Slack to this test

  test "should update exercise" do
    patch exercise_path(@exercise), params: {
      exercise: {
        reps_bool: true,
        exercise_elements_attributes: {
          "0": {
            element_id: @element1.id.to_s, "_destroy": "0"
          },
          "1": {
            element_id: @element2.id.to_s, "_destroy": "0"
          },
          "2": {
            element_id: elements(:element_1).id.to_s, "_destroy": "0"
          }
        }
      }
    }
    assert_redirected_to exercises_path
  end

  test "should destroy exercise" do
    assert_difference('Exercise.count', -1) do
      delete exercise_url(@exercise)
    end

    assert_redirected_to exercises_path
  end
end
