require 'test_helper'


class ExerciseIndexTest < ActionDispatch::IntegrationTest
  test "should return filtered results" do
    get exercises_path, params: {
      query: ["Prone"]
    }
  end
end
