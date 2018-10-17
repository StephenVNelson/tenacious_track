class AddCategoryIdToElements < ActiveRecord::Migration[5.1]
  def change
    add_column :elements, :category_id, :integer
  end
end
