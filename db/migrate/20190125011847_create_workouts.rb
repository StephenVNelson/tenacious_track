class CreateWorkouts < ActiveRecord::Migration[5.1]
  def change
    create_table :workouts do |t|
      t.integer :trainer_id
      t.integer :client_id
      t.date :scheduled_date
      t.datetime :logged_date
      t.integer :phase_number
      t.integer :week_number
      t.integer :day_number
      t.string :workout_focus
      t.integer :sets
      t.integer :reps
      t.string :resistance
      t.integer :duration_min
      t.integer :duration_sec

      t.timestamps
    end
  end
end
