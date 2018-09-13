class CreateElements < ActiveRecord::Migration[5.1]
  def change
    create_table :elements do |t|
      t.string :series_name
      t.string :name

      t.timestamps
    end
  end
end
