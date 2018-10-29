class RemoveLeftRightBoolFromExercise < ActiveRecord::Migration[5.1]
  def change
    remove_column :exercises, :right_left_bool, :boolean
  end
end
