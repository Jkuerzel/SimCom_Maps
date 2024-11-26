class AddRobotsToMapBuilding < ActiveRecord::Migration[6.0] # Update version number if needed
  def change
    add_column :map_buildings, :robots, :boolean, default: false, null: false
  end
end
