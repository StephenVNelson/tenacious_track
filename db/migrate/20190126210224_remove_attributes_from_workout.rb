class RemoveAttributesFromWorkout < ActiveRecord::Migration[5.1]
  def change
    remove_column :workouts, :sets, :integer
    remove_column :workouts, :reps, :integer
    remove_column :workouts, :resistance, :string
    remove_column :workouts, :duration_min, :integer
    remove_column :workouts, :duration_sec, :integer
  end
end
