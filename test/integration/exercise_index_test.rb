require 'test_helper'

# TODO: Create test for filtering id:20

class ExerciseIndexTest < ActionDispatch::IntegrationTest
  test "should return filtered results" do
    get exercises_path, params: {
      query: ["Prone"]
    }
  end
end
