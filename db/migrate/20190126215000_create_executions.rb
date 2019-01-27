class CreateExecutions < ActiveRecord::Migration[5.1]
  def change
    create_table :executions do |t|
      t.references :exercise, foreign_key: true, index: true
      t.references :workout, foreign_key: true, index: true
      t.integer :sets
      t.integer :reps
      t.string :resistance
      t.integer :seconds

      t.timestamps
    end
  end
end
