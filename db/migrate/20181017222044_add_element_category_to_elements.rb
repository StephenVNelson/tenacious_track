class AddElementCategoryToElements < ActiveRecord::Migration[5.1]
  def change
    add_reference :elements, :element_category, foreign_key: true
  end
end
