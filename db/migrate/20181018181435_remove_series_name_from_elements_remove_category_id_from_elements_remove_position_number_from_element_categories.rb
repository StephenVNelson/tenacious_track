class RemoveSeriesNameFromElementsRemoveCategoryIdFromElementsRemovePositionNumberFromElementCategories < ActiveRecord::Migration[5.1]
  def change
    remove_column :elements, :series_name, :string
    remove_column :elements, :category_id, :integer
    remove_column :element_categories, :position_number, :integer
  end
end
