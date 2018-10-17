class AddSortToElementCategory < ActiveRecord::Migration[5.1]
  def change
    add_column :element_categories, :sort, :integer
  end
end
