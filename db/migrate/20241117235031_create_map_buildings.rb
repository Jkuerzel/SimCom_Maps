class CreateMapBuildings < ActiveRecord::Migration[7.1]
  def change
    create_table :map_buildings do |t|
      t.integer :map_id
      t.integer :building_id
      t.integer :position_id
      t.integer :level

      t.timestamps
    end
  end
end
