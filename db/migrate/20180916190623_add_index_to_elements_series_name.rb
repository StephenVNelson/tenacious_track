class AddIndexToElementsSeriesName < ActiveRecord::Migration[5.1]
  def change
    add_index :elements, :series_name
    add_index :elements, :name, unique: true
  end
end
