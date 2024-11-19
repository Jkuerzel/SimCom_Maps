class AddProductionBuildingsCountToMapBuildings < ActiveRecord::Migration[7.1]
  def change
    add_column :map_buildings, :production_buildings_count, :integer
  end
end
