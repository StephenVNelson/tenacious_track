class ChangeBooleanDefaultValuesInExerciseModel < ActiveRecord::Migration[5.1]
  def change
    change_column_default :exercises, :right_left_bool, false
    change_column_default :exercises, :reps_bool, false
    change_column_default :exercises, :resistance_bool, false
    change_column_default :exercises, :duration_bool, false
    change_column_default :exercises, :work_rest_bool, false
  end
end

  #DONE: Created default to false to avoid three state boolean problem https://robots.thoughtbot.com/avoid-the-threestate-boolean-problem
