class RemoveCategoryFromExecution < ActiveRecord::Migration[5.1]
  def change
    remove_column :executions, :category, :string
  end
end
