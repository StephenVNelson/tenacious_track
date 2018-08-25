class AddColumnsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :hire_date, :date
  end
end
