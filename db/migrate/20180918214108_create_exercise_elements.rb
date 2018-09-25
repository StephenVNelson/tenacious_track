class CreateExerciseElements < ActiveRecord::Migration[5.1]
  def change
    create_table :exercise_elements do |t|
      t.integer :exercise_id
      t.integer :element_id

      t.timestamps
    end
    add_index :exercise_elements, :exercise_id
    add_index :exercise_elements, :element_id
    add_index :exercise_elements, [:exercise_id, :element_id], unique: true
  end
end
