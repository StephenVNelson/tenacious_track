class AddIndexToElementsSeriesNameAndName < ActiveRecord::Migration[5.1]
  def change
    add_index :elements, [:series_name, :name], unique: true
  end
end
