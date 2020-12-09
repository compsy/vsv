class AddCollapseDuplicatesToMeasurement < ActiveRecord::Migration[5.2]
  def change
    add_column :measurements, :collapse_duplicates, :boolean, null: false, default: true
  end
end
