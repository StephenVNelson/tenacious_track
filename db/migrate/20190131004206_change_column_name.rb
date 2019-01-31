class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :clients, :weekly_committment, :weekly_commitment
  end
end
