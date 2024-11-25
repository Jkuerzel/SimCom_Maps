class AddAbundanceToMapBuildings < ActiveRecord::Migration[6.1]
  def change
    # Add the new column with a default value and not allowing null values
    add_column :map_buildings, :abundance, :integer, default: 100, null: false

    # Update existing records to have abundance of 100
    reversible do |dir|
      dir.up { MapBuilding.update_all(abundance: 100) }
    end
  end
end
