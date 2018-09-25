class CreateExercises < ActiveRecord::Migration[5.1]
  def change
    create_table :exercises do |t|
      t.boolean :right_left_bool
      t.boolean :reps_bool
      t.boolean :resistance_bool
      t.boolean :duration_bool
      t.string :gif_link

      t.timestamps
    end
  end
end
