class AddColumnsToMapBuildings < ActiveRecord::Migration[7.1]
  def change
    add_column :map_buildings, :production_time, :integer
    add_column :map_buildings, :quality_level, :integer
    add_column :map_buildings, :product_id, :integer
  end
end
