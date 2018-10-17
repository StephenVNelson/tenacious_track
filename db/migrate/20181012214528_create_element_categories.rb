class CreateElementCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :element_categories do |t|
      t.string :category_name
      t.integer :position_number

      t.timestamps
    end
  end
end
