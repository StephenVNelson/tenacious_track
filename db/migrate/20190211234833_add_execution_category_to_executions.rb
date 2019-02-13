class AddExecutionCategoryToExecutions < ActiveRecord::Migration[5.1]
  def change
    add_reference :executions, :execution_category, foreign_key: true
  end
end
