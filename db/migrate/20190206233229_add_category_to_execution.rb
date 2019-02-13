class AddCategoryToExecution < ActiveRecord::Migration[5.1]
  def change
    add_column :executions, :category, :string
    add_index :executions, :category
  end
end
